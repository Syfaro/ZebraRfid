@preconcurrency import Combine
import ZebraRfidSdkFramework

public enum RfidError: Error, Sendable {
  case statusMessage(RfidStatus, String)
  case badResultCode(RfidStatus)
  case badParameter(String)
  case unsuccessfulOperation(RfidNamedAccessOperationCode)
  case timeout
}

public enum RfidEvent: Equatable, Sendable {
  case readerAppeared(RfidReaderInfo)
  case readerDisappeared(Int32)
  case communicationSessionEstablished(RfidReaderInfo)
  case communicationSessionTerminated(Int32)
  case read(Int32, RfidTagData)
  case status(Int32, RfidEventStatus)
  case proximity(Int32, Int32)
  case multiProximity(Int32, RfidTagData)
  case trigger(Int32, RfidTriggerEvent)
  case battery(Int32, RfidBatteryEvent)
  case wlan(Int32, RfidWlanScanEntry)
}

public actor RfidSdkManager {
  let eventPublisher: AnyPublisher<RfidEvent, Never>
  let delegate: RfidDelegate

  var api: srfidISdkApi!

  public init() {
    let passthroughSubject = PassthroughSubject<RfidEvent, Never>()
    delegate = RfidDelegate(publisher: passthroughSubject)
    eventPublisher = passthroughSubject.eraseToAnyPublisher()
  }

  public func events() -> AsyncStream<RfidEvent> {
    return AsyncStream<RfidEvent> { continuation in
      let cancellable = eventPublisher.sink { event in
        continuation.yield(event)
      }

      continuation.onTermination = { _ in
        cancellable.cancel()
      }
    }
  }

  public func start() throws {
    api = srfidSdkFactory.createRfidSdkApiInstance()
    try checkResult(api.srfidSetDelegate(delegate))
  }

  public func sdkVersion() throws -> String {
    return api.srfidGetSdkVersion()
  }

  public func setOperationMode(_ operationMode: RfidOperatingMode = .all) throws {
    try checkResult(api.srfidSetOperationalMode(operationMode.rawValue))
  }

  public func subscribe(events: RfidEventMask = .all) throws {
    try checkResult(api.srfidSubsribe(forEvents: events.rawValue))
  }

  public func unsubscribe(events: RfidEventMask) throws {
    try checkResult(api.srfidUnsubsribe(forEvents: events.rawValue))
  }

  public func getAvailableReaders() throws -> [RfidReaderInfo] {
    var readers: NSMutableArray? = .init()
    try checkResult(api.srfidGetAvailableReadersList(&readers))
    return readers!.map { RfidReaderInfo($0 as! srfidReaderInfo) }
  }

  public func getActiveReaders() throws -> [RfidReaderInfo] {
    var readers: NSMutableArray? = .init()
    try checkResult(api.srfidGetActiveReadersList(&readers))
    return readers!.map { RfidReaderInfo($0 as! srfidReaderInfo) }
  }

  public func establishCommunicationSession(readerID: Int32) throws {
    try checkResult(api.srfidEstablishCommunicationSession(readerID))
  }

  public func terminateCommunicationSession(readerID: Int32) throws {
    try checkResult(api.srfidTerminateCommunicationSession(readerID))
  }

  public func establishAsciiConnection(readerID: Int32, password: String? = nil) throws {
    try checkResult(api.srfidEstablishAsciiConnection(readerID, aPassword: password ?? ""))
  }

  public func enableAvailableReadersDetection(_ enable: Bool = true) throws {
    try checkResult(api.srfidEnableAvailableReadersDetection(enable))
  }

  public func enableAutomaticSessionReestablishment(_ enable: Bool = true) throws {
    try checkResult(api.srfidEnableAutomaticSessionReestablishment(enable))
  }

  public func startRapidRead(
    readerID: Int32,
    reportConfig: RfidReportConfig,
    accessConfig: RfidAccessConfig
  ) throws {
    try checkResult { api, statusMessage in
      return api.srfidStartRapidRead(
        readerID,
        aReportConfig: reportConfig.srfidValue,
        aAccessConfig: accessConfig.srfidValue,
        aStatusMessage: &statusMessage
      )
    }
  }

  public func stopRapidRead(readerID: Int32) throws {
    try checkResult { api, statusMessage in
      return api.srfidStopRapidRead(readerID, aStatusMessage: &statusMessage)
    }
  }

  public func startInventory(
    readerID: Int32,
    memoryBank: RfidMemoryBank,
    reportConfig: RfidReportConfig,
    accessConfig: RfidAccessConfig
  ) throws {
    try checkResult { api, statusMessage in
      return api.srfidStartInventory(
        readerID,
        aMemoryBank: memoryBank.srfidValue,
        aReportConfig: reportConfig.srfidValue,
        aAccessConfig: accessConfig.srfidValue,
        aStatusMessage: &statusMessage
      )
    }
  }

  public func stopInventory(readerID: Int32) throws {
    try checkResult { api, statusMessage in
      return api.srfidStopInventory(readerID, aStatusMessage: &statusMessage)
    }
  }

  public func getSupportedLinkProfiles(readerID: Int32) throws -> [RfidLinkProfile] {
    var linkProfiles: NSMutableArray? = .init()
    try checkResult { api, statusMessage in
      return api.srfidGetSupportedLinkProfiles(
        readerID,
        aLinkProfilesList: &linkProfiles,
        aStatusMessage: &statusMessage
      )
    }
    return linkProfiles!.map { RfidLinkProfile($0 as! srfidLinkProfile) }
  }

  public func getAntennaConfig(readerID: Int32) throws -> RfidAntennaConfig {
    var config: srfidAntennaConfiguration? = .init()
    try checkResult { api, statusMessage in
      return api.srfidGetAntennaConfiguration(
        readerID,
        aAntennaConfiguration: &config,
        aStatusMessage: &statusMessage
      )
    }
    return RfidAntennaConfig(config!)
  }

  public func setAntennaConfig(readerID: Int32, config: RfidAntennaConfig) throws {
    try checkResult { api, statusMessage in
      return api.srfidSetAntennaConfiguration(
        readerID,
        aAntennaConfiguration: config.srfidValue,
        aStatusMessage: &statusMessage
      )
    }
  }

  public func getDPOConfig(readerID: Int32) throws -> RfidDynamicPowerConfig {
    var config: srfidDynamicPowerConfig? = .init()
    try checkResult { api, statusMessage in
      return api.srfidGetDpoConfiguration(
        readerID,
        aDpoConfiguration: &config,
        aStatusMessage: &statusMessage
      )
    }
    return RfidDynamicPowerConfig(config!)
  }

  public func setDPOConfig(readerID: Int32, config: RfidDynamicPowerConfig) throws {
    try checkResult { api, statusMessage in
      return api.srfidSetDpoConfiguration(
        readerID,
        aDpoConfiguration: config.srfidValue,
        aStatusMessage: &statusMessage
      )
    }
  }

  public func getSingulationConfig(readerID: Int32) throws -> RfidSingulationConfig {
    var config: srfidSingulationConfig? = .init()
    try checkResult { api, statusMessage in
      return api.srfidGetSingulationConfiguration(
        readerID,
        aSingulationConfig: &config,
        aStatusMessage: &statusMessage
      )
    }
    return RfidSingulationConfig(config!)
  }

  public func setSingulationConfig(readerID: Int32, config: RfidSingulationConfig) throws {
    try checkResult { api, statusMessage in
      return api.srfidSetSingulationConfiguration(
        readerID,
        aSingulationConfig: config.srfidValue,
        aStatusMessage: &statusMessage
      )
    }
  }

  public func getTagReportConfig(readerID: Int32) throws -> RfidTagReportConfig {
    var config: srfidTagReportConfig? = .init()
    try checkResult { api, statusMessage in
      return api.srfidGetTagReportConfiguration(
        readerID,
        aTagReportConfig: &config,
        aStatusMessage: &statusMessage
      )
    }
    return RfidTagReportConfig(config!)
  }

  public func setTagReportConfig(readerID: Int32, config: RfidTagReportConfig) throws {
    try checkResult { api, statusMessage in
      return api.srfidSetTagReportConfiguration(
        readerID,
        aTagReportConfig: config.srfidValue,
        aStatusMessage: &statusMessage
      )
    }
  }

  public func saveReaderConfig(readerID: Int32, saveCustomDefaults: Bool) throws {
    try checkResult { api, statusMessage in
      return api.srfidSaveReaderConfiguration(
        readerID,
        aSaveCustomDefaults: saveCustomDefaults,
        aStatusMessage: &statusMessage
      )
    }
  }

  public func restoreReaderConfig(readerID: Int32, restoreFactoryDefaults: Bool) throws {
    try checkResult { api, statusMessage in
      return api.srfidRestoreReaderConfiguration(
        readerID,
        aRestoreFactoryDefaults: restoreFactoryDefaults,
        aStatusMessage: &statusMessage
      )
    }
  }

  public func getReaderVersionInfo(readerID: Int32) throws -> RfidReaderVersionInfo {
    var versionInfo: srfidReaderVersionInfo? = .init()
    try checkResult { api, statusMessage in
      return api.srfidGetReaderVersionInfo(
        readerID,
        aReaderVersionInfo: &versionInfo,
        aStatusMessage: &statusMessage
      )
    }
    return RfidReaderVersionInfo(versionInfo!)
  }

  public func getReaderCapabilitiesInfo(readerID: Int32) throws -> RfidReaderCapabilitiesInfo {
    var capabilityInfo: srfidReaderCapabilitiesInfo? = .init()
    try checkResult { api, statusMessage in
      return api.srfidGetReaderCapabilitiesInfo(
        readerID,
        aReaderCapabilitiesInfo: &capabilityInfo,
        aStatusMessage: &statusMessage
      )
    }
    return RfidReaderCapabilitiesInfo(capabilityInfo!)
  }

  public func getStartTriggerConfig(readerID: Int32) throws -> RfidStartTriggerConfig {
    var config: srfidStartTriggerConfig? = .init()
    try checkResult { api, statusMessage in
      return api.srfidGetStartTriggerConfiguration(
        readerID,
        aStartTriggeConfig: &config,
        aStatusMessage: &statusMessage
      )
    }
    return RfidStartTriggerConfig(config!)
  }

  public func setStartTriggerConfig(readerID: Int32, config: RfidStartTriggerConfig) throws {
    try checkResult { api, statusMessage in
      return api.srfidSetStartTriggerConfiguration(
        readerID,
        aStartTriggeConfig: config.srfidValue,
        aStatusMessage: &statusMessage
      )
    }
  }

  public func getStopTriggerConfig(readerID: Int32) throws -> RfidStopTriggerConfig {
    var config: srfidStopTriggerConfig? = .init()
    try checkResult { api, statusMessage in
      return api.srfidGetStopTriggerConfiguration(
        readerID,
        aStopTriggeConfig: &config,
        aStatusMessage: &statusMessage
      )
    }
    return RfidStopTriggerConfig(config!)
  }

  public func setStopTriggerConfig(readerID: Int32, config: RfidStopTriggerConfig) throws {
    try checkResult { api, statusMessage in
      return api.srfidSetStopTriggerConfiguration(
        readerID,
        aStopTriggeConfig: config.srfidValue,
        aStatusMessage: &statusMessage
      )
    }
  }

  public func getSupportedRegions(readerID: Int32) throws -> [RfidSupportedRegion] {
    var regions: NSMutableArray? = .init()
    try checkResult { api, statusMessage in
      return api.srfidGetSupportedRegions(
        readerID,
        aSupportedRegions: &regions,
        aStatusMessage: &statusMessage
      )
    }
    return regions!.map { RfidSupportedRegion($0 as! srfidRegionInfo) }
  }

  public func getRegionInfo(readerID: Int32, regionCode: String) throws -> RfidRegionInfo {
    var supportedChannels: NSMutableArray? = .init()
    var hoppingConfigurable: ObjCBool = false
    try checkResult { api, statusMessage in
      return api.srfidGetRegionInfo(
        readerID,
        aRegionCode: regionCode,
        aSupportedChannels: &supportedChannels,
        aHoppingConfigurable: &hoppingConfigurable,
        aStatusMessage: &statusMessage
      )
    }
    return RfidRegionInfo(
      supportedChannels: supportedChannels!.map { $0 as! String },
      hoppingConfigurable: hoppingConfigurable.boolValue
    )
  }

  public func getRegulatoryConfig(readerID: Int32) throws -> RfidRegulatoryConfig {
    var config: srfidRegulatoryConfig? = .init()
    try checkResult { api, statusMessage in
      return api.srfidGetRegulatoryConfig(
        readerID,
        aRegulatoryConfig: &config,
        aStatusMessage: &statusMessage
      )
    }
    return RfidRegulatoryConfig(config!)
  }

  public func setRegulatoryConfig(readerID: Int32, config: RfidRegulatoryConfig) throws {
    try checkResult { api, statusMessage in
      return api.srfidSetRegulatoryConfig(
        readerID,
        aRegulatoryConfig: config.srfidValue,
        aStatusMessage: &statusMessage
      )
    }
  }

  public func getBeeperConfig(readerID: Int32) throws -> RfidBeeperConfig {
    var config = SRFID_BEEPERCONFIG_HIGH
    try checkResult { api, statusMessage in
      return api.srfidGetBeeperConfig(
        readerID,
        aBeeperConfig: &config,
        aStatusMessage: &statusMessage
      )
    }
    return RfidBeeperConfig(config)
  }

  public func setBeeperConfig(readerID: Int32, config: RfidBeeperConfig) throws {
    try checkResult { api, statusMessage in
      return api.srfidSetBeeperConfig(
        readerID,
        aBeeperConfig: config.srfidValue,
        aStatusMessage: &statusMessage
      )
    }
  }

  public func getPreFilters(readerID: Int32) throws -> [RfidPreFilter] {
    var preFilters: NSMutableArray? = .init()
    try checkResult { api, statusMessage in
      return api.srfidGetPreFilters(
        readerID,
        aPreFilters: &preFilters,
        aStatusMessage: &statusMessage
      )
    }
    return preFilters!.map { RfidPreFilter($0 as! srfidPreFilter) }
  }

  public func setPreFilters(readerID: Int32, preFilters: [RfidPreFilter]) throws {
    try checkResult { api, statusMessage in
      return api.srfidSetPreFilters(
        readerID,
        aPreFilters: NSMutableArray(array: preFilters),
        aStatusMessage: &statusMessage
      )
    }
  }

  public func startTagLocationing(readerID: Int32, epc: String) throws {
    try checkResult { api, statusMessage in
      return api.srfidStartTagLocationing(
        readerID,
        aTagEpcId: epc,
        aStatusMessage: &statusMessage
      )
    }
  }

  public func stopTagLocationing(readerID: Int32) throws {
    try checkResult { api, statusMessage in
      return api.srfidStopTagLocationing(readerID, aStatusMessage: &statusMessage)
    }
  }

  public func readTag(
    readerID: Int32,
    epc: String,
    memoryBank: RfidMemoryBank,
    length: Int16,
    offset: Int16 = 0,
    password: String? = nil
  ) throws -> RfidTagData {
    let password = try decodeHex(password ?? "00", name: "password")

    var tagData: srfidTagData? = .init()
    try checkResult { api, statusMessage in
      return api.srfidReadTag(
        readerID,
        aTagID: epc,
        aAccessTagData: &tagData,
        aMemoryBank: memoryBank.srfidValue,
        aOffset: offset,
        aLength: length,
        aPassword: password,
        aStatusMessage: &statusMessage
      )
    }
    return RfidTagData(tagData!)
  }

  public func readTag(
    readerID: Int32,
    accessCriteria: RfidAccessCriteria,
    memoryBank: RfidMemoryBank,
    length: Int16,
    offset: Int16 = 0,
    password: String? = nil
  ) throws -> RfidTagData {
    let password = try decodeHex(password ?? "00", name: "password")

    var tagData: srfidTagData? = .init()
    try checkResult { api, statusMessage in
      return api.srfidReadTag(
        readerID,
        aAccessCriteria: accessCriteria.srfidValue,
        aAccessTagData: &tagData,
        aMemoryBank: memoryBank.srfidValue,
        aOffset: offset,
        aLength: length,
        aPassword: password,
        aStatusMessage: &statusMessage
      )
    }
    return RfidTagData(tagData!)
  }

  public func writeTag(
    readerID: Int32,
    epc: String,
    memoryBank: RfidMemoryBank,
    offset: Int16,
    data: String,
    blockWrite: Bool = false,
    password: String? = nil
  ) throws -> RfidTagData {
    let password = try decodeHex(password ?? "00", name: "password")

    var tagData: srfidTagData? = .init()
    try checkResult { api, statusMessage in
      return api.srfidWriteTag(
        readerID,
        aTagID: epc,
        aAccessTagData: &tagData,
        aMemoryBank: memoryBank.srfidValue,
        aOffset: offset,
        aData: data,
        aPassword: password,
        aDoBlockWrite: blockWrite,
        aStatusMessage: &statusMessage
      )
    }
    return RfidTagData(tagData!)
  }

  public func writeTag(
    readerID: Int32,
    accessCriteria: RfidAccessCriteria,
    memoryBank: RfidMemoryBank,
    offset: Int16,
    data: String,
    blockWrite: Bool = false,
    password: String? = nil
  ) throws -> RfidTagData {
    let password = try decodeHex(password ?? "00", name: "password")

    var tagData: srfidTagData? = .init()
    try checkResult { api, statusMessage in
      return api.srfidWriteTag(
        readerID,
        aAccessCriteria: accessCriteria.srfidValue,
        aAccessTagData: &tagData,
        aMemoryBank: memoryBank.srfidValue,
        aOffset: offset,
        aData: data,
        aPassword: password,
        aDoBlockWrite: blockWrite,
        aStatusMessage: &statusMessage
      )
    }
    return RfidTagData(tagData!)
  }

  public func killTag(readerID: Int32, epc: String, password: String? = nil) throws -> RfidTagData {
    let password = try decodeHex(password ?? "00", name: "password")

    var tagData: srfidTagData? = .init()
    try checkResult { api, statusMessage in
      return api.srfidKillTag(
        readerID,
        aTagID: epc,
        aAccessTagData: &tagData,
        aPassword: password,
        aStatusMessage: &statusMessage
      )
    }
    return RfidTagData(tagData!)
  }

  public func killTag(
    readerID: Int32,
    accessCriteria: RfidAccessCriteria,
    password: String? = nil
  ) throws -> RfidTagData {
    let password = try decodeHex(password ?? "00", name: "password")

    var tagData: srfidTagData? = .init()
    try checkResult { api, statusMessage in
      return api.srfidKillTag(
        readerID,
        aAccessCriteria: accessCriteria.srfidValue,
        aAccessTagData: &tagData,
        aPassword: password,
        aStatusMessage: &statusMessage
      )
    }
    return RfidTagData(tagData!)
  }

  public func lockTag(
    readerID: Int32,
    epc: String,
    memoryBank: RfidMemoryBank,
    accessPermissions: RfidAccessPermission,
    password: String? = nil
  ) throws -> RfidTagData {
    let password = try decodeHex(password ?? "00", name: "password")

    var tagData: srfidTagData? = .init()
    try checkResult { api, statusMessage in
      return api.srfidLockTag(
        readerID,
        aTagID: epc,
        aAccessTagData: &tagData,
        aMemoryBank: memoryBank.srfidValue,
        aAccessPermissions: accessPermissions.srfidValue,
        aPassword: password,
        aStatusMessage: &statusMessage
      )
    }
    return RfidTagData(tagData!)
  }

  public func lockTag(
    readerID: Int32,
    accessCriteria: RfidAccessCriteria,
    memoryBank: RfidMemoryBank,
    accessPermissions: RfidAccessPermission,
    password: String? = nil
  ) throws -> RfidTagData {
    let password = try decodeHex(password ?? "00", name: "password")

    var tagData: srfidTagData? = .init()
    try checkResult { api, statusMessage in
      return api.srfidLockTag(
        readerID,
        aAccessCriteria: accessCriteria.srfidValue,
        aAccessTagData: &tagData,
        aMemoryBank: memoryBank.srfidValue,
        aAccessPermissions: accessPermissions.srfidValue,
        aPassword: password,
        aStatusMessage: &statusMessage
      )
    }
    return RfidTagData(tagData!)
  }

  public func requestBatteryStatus(readerID: Int32) throws {
    try checkResult(api.srfidRequestBatteryStatus(readerID))
  }

  public func getBatchModeConfig(readerID: Int32) throws -> RfidBatchModeConfig {
    var config = SRFID_BATCHMODECONFIG_DISABLE
    try checkResult { api, statusMessage in
      return api.srfidGetBatchModeConfig(
        readerID,
        aBatchModeConfig: &config,
        aStatusMessage: &statusMessage
      )
    }
    return RfidBatchModeConfig(config)
  }

  public func setBatchModeConfig(readerID: Int32, config: RfidBatchModeConfig) throws {
    try checkResult { api, statusMessage in
      return api.srfidSetBatchModeConfig(
        readerID,
        aBatchModeConfig: config.srfidValue,
        aStatusMessage: &statusMessage
      )
    }
  }

  public func getTags(readerID: Int32) throws {
    try checkResult { api, statusMessage in
      return api.srfidgetTags(readerID, aStatusMessage: &statusMessage)
    }
  }

  public func getConfigs() throws {
    try checkResult(api.srfidGetConfigurations())
  }

  public func purgeTags(readerID: Int32) throws {
    try checkResult { api, statusMessage in
      return api.srfidPurgeTags(readerID, aStatusMessage: &statusMessage)
    }
  }

  public func blockErase(
    readerID: Int32,
    epc: String,
    memoryBank: RfidMemoryBank,
    length: Int16,
    offset: Int16 = 0,
    password: String? = nil
  ) throws -> RfidTagData {
    let password = try decodeHex(password ?? "00", name: "password")

    var tagData: srfidTagData? = .init()
    try checkResult { api, statusMessage in
      return api.srfidBlockErase(
        readerID,
        aTagID: epc,
        aAccessTagData: &tagData,
        aMemoryBank: memoryBank.srfidValue,
        aOffset: offset,
        aLength: length,
        aPassword: password,
        aStatusMessage: &statusMessage
      )
    }
    return RfidTagData(tagData!)
  }

  public func blockErase(
    readerID: Int32,
    accessCriteria: RfidAccessCriteria,
    memoryBank: RfidMemoryBank,
    length: Int16,
    offset: Int16 = 0,
    password: String? = nil
  ) throws -> RfidTagData {
    let password = try decodeHex(password ?? "00", name: "password")

    var tagData: srfidTagData? = .init()
    try checkResult { api, statusMessage in
      return api.srfidBlockErase(
        readerID,
        aAccessCriteria: accessCriteria.srfidValue,
        aAccessTagData: &tagData,
        aMemoryBank: memoryBank.srfidValue,
        aOffset: offset,
        aLength: length,
        aPassword: password,
        aStatusMessage: &statusMessage
      )
    }
    return RfidTagData(tagData!)
  }

  public func blockPermaLock(
    readerID: Int32,
    epc: String,
    memoryBank: RfidMemoryBank,
    lock: Bool,
    blockPointer: Int16,
    blockRange: Int16,
    blockMask: String,
    password: String? = nil
  ) throws -> RfidTagData {
    let password = try decodeHex(password ?? "00", name: "password")

    var tagData: srfidTagData? = .init()
    try checkResult { api, statusMessage in
      return api.srfidBlockPermaLock(
        readerID,
        aTagID: epc,
        aAccessTagData: &tagData,
        aMemoryBank: memoryBank.srfidValue,
        aDoLock: lock,
        aBlockPtr: blockPointer,
        aBlockRange: blockRange,
        aBlockMask: blockMask,
        aPassword: password,
        aStatusMessage: &statusMessage
      )
    }
    return RfidTagData(tagData!)
  }

  public func blockPermaLock(
    readerID: Int32,
    accessCriteria: RfidAccessCriteria,
    memoryBank: RfidMemoryBank,
    lock: Bool,
    blockPointer: Int16,
    blockRange: Int16,
    blockMask: String,
    password: String? = nil
  ) throws -> RfidTagData {
    let password = try decodeHex(password ?? "00", name: "password")

    var tagData: srfidTagData? = .init()
    try checkResult { api, statusMessage in
      return api.srfidBlockPermaLock(
        readerID,
        aAccessCriteria: accessCriteria.srfidValue,
        aAccessTagData: &tagData,
        aMemoryBank: memoryBank.srfidValue,
        aDoLock: lock,
        aBlockPtr: blockPointer,
        aBlockRange: blockRange,
        aBlockMask: blockMask,
        aPassword: password,
        aStatusMessage: &statusMessage
      )
    }
    return RfidTagData(tagData!)
  }

  public func getAttribute(readerID: Int32, number: Int32) throws -> RfidAttribute {
    var attribute: srfidAttribute? = .init()
    try checkResult { api, statusMessage in
      return api.srfidGetAttribute(
        readerID, aAttrNum: number,
        aAttrInfo: &attribute,
        aStatusMessage: &statusMessage
      )
    }
    return RfidAttribute(attribute!)
  }

  public func setAttribute(
    readerID: Int32,
    number: Int32,
    value: Int32,
    attributeType: String
  ) throws {
    try checkResult { api, statusMessage in
      return api.srfidSetAttribute(
        readerID,
        attributeNumber: number,
        attributeValue: value,
        attributeType: attributeType,
        aStatusMessage: &statusMessage
      )
    }
  }

  public func setAccessCommandOperationWaitTimeout(readerID: Int32, timeout: Int32) throws {
    try checkResult(api.srfidSetAccessCommandOperationWaitTimeout(readerID, aTimeoutMs: timeout))
  }

  public func locateReader(readerID: Int32, enabled: Bool) throws {
    try checkResult { api, statusMessage in
      return api.srfidLocateReader(readerID, doEnabled: enabled, aStatusMessage: &statusMessage)
    }
  }

  func checkResult(_ result: SRFID_RESULT) throws {
    let rfidStatus = RfidStatus(result)
    guard rfidStatus == .success else {
      throw RfidError.badResultCode(rfidStatus)
    }
  }

  func checkResult(
    _ action: (srfidISdkApi, inout NSString?) throws -> SRFID_RESULT,
    manager: isolated RfidSdkManager = #isolation
  ) throws {
    var statusMessage: NSString?
    let rfidStatus = RfidStatus(try action(manager.api, &statusMessage))
    guard rfidStatus == .success else {
      if let statusMessage, statusMessage.length > 0 {
        throw RfidError.statusMessage(rfidStatus, String(statusMessage))
      } else {
        throw RfidError.badResultCode(rfidStatus)
      }
    }
  }

  func decodeHex(_ input: String, name: String) throws -> Int {
    if let value = Int(input, radix: 16) {
      return value
    } else {
      throw RfidError.badParameter(name)
    }
  }
}

class RfidDelegate: NSObject, srfidISdkApiDelegate {
  private let publisher: PassthroughSubject<RfidEvent, Never>

  init(publisher: PassthroughSubject<RfidEvent, Never>) {
    self.publisher = publisher
  }

  func srfidEventReaderAppeared(_ availableReader: srfidReaderInfo!) {
    publisher.send(.readerAppeared(.init(availableReader)))
  }

  func srfidEventReaderDisappeared(_ readerID: Int32) {
    publisher.send(.readerDisappeared(readerID))
  }

  func srfidEventCommunicationSessionEstablished(_ activeReader: srfidReaderInfo!) {
    publisher.send(.communicationSessionEstablished(.init(activeReader)))
  }

  func srfidEventCommunicationSessionTerminated(_ readerID: Int32) {
    publisher.send(.communicationSessionTerminated(readerID))
  }

  func srfidEventReadNotify(_ readerID: Int32, aTagData tagData: srfidTagData!) {
    publisher.send(.read(readerID, .init(tagData)))
  }

  func srfidEventStatusNotify(
    _ readerID: Int32,
    aEvent event: SRFID_EVENT_STATUS,
    aNotification notificationData: Any!
  ) {
    publisher.send(.status(readerID, .init(event)))
  }

  func srfidEventProximityNotify(_ readerID: Int32, aProximityPercent proximityPercent: Int32) {
    publisher.send(.proximity(readerID, proximityPercent))
  }

  func srfidEventMultiProximityNotify(_ readerID: Int32, aTagData tagData: srfidTagData!) {
    publisher.send(.multiProximity(readerID, RfidTagData(tagData)))
  }

  func srfidEventTriggerNotify(_ readerID: Int32, aTriggerEvent triggerEvent: SRFID_TRIGGEREVENT) {
    publisher.send(.trigger(readerID, .init(triggerEvent)))
  }

  func srfidEventBatteryNotity(_ readerID: Int32, aBatteryEvent batteryEvent: srfidBatteryEvent!) {
    publisher.send(.battery(readerID, .init(batteryEvent)))
  }

  func srfidEventWifiScan(_ readerID: Int32, wlanSCanObject wlanScanObject: srfidWlanScanList!) {
    publisher.send(.wlan(readerID, .init(wlanScanObject)))
  }
}
