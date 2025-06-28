import ZebraRfidSdkFramework

protocol SRFIDConvertable {
  associatedtype SRFID

  init(_: SRFID)
  var srfidValue: SRFID { get }
}

public enum RfidStatus: UInt32, Sendable, SRFIDConvertable {
  case success = 0
  case failure = 1
  case readerNotAvailable = 2
  case invalidParams = 4
  case responseTimeout = 5
  case notSupported = 6
  case responseError = 7
  case wrongAsciiPassword = 8
  case asciiConnectionRequired = 9

  init(_ result: SRFID_RESULT) {
    self.init(rawValue: result.rawValue)!
  }

  var srfidValue: SRFID_RESULT {
    SRFID_RESULT(UInt32(self.rawValue))
  }
}

public enum RfidOperatingMode: Int32, Sendable {
  case mfi = 1
  case btle = 2
  case all = 3
}

public enum RfidConnectionType: Int32, Sendable {
  case invalid = 0
  case mfi = 1
  case btle = 2
}

public struct RfidEventMask: OptionSet, Sendable {
  public static let all: RfidEventMask = [
    .readerAppearance,
    .readerDisappearance,
    .sessionEstablishment,
    .sessionTermination,
    .read,
    .status,
    .proximity,
    .trigger,
    .battery,
    .operationEndSummary,
    .temperature,
    .power,
    .database,
    .radioError,
    .multiProximity,
    .wlanScan,
  ]

  public static let readerAppearance = RfidEventMask(rawValue: 1 << 1)
  public static let readerDisappearance = RfidEventMask(rawValue: 1 << 2)
  public static let sessionEstablishment = RfidEventMask(rawValue: 1 << 3)
  public static let sessionTermination = RfidEventMask(rawValue: 1 << 4)
  public static let read = RfidEventMask(rawValue: 1 << 5)
  public static let status = RfidEventMask(rawValue: 1 << 6)
  public static let proximity = RfidEventMask(rawValue: 1 << 7)
  public static let trigger = RfidEventMask(rawValue: 1 << 8)
  public static let battery = RfidEventMask(rawValue: 1 << 9)
  public static let operationEndSummary = RfidEventMask(rawValue: 1 << 10)
  public static let temperature = RfidEventMask(rawValue: 1 << 11)
  public static let power = RfidEventMask(rawValue: 1 << 12)
  public static let database = RfidEventMask(rawValue: 1 << 13)
  public static let radioError = RfidEventMask(rawValue: 1 << 14)
  public static let multiProximity = RfidEventMask(rawValue: 1 << 15)
  public static let wlanScan = RfidEventMask(rawValue: 1 << 16)

  public let rawValue: Int32

  public init(rawValue: Int32) {
    self.rawValue = rawValue
  }
}

public enum RfidEventStatus: UInt32, Sendable, SRFIDConvertable {
  case operationStart = 0x00
  case operationStop = 0x01
  case operationBatchMode = 0x02
  case operationEndSummary = 0x03
  case operationFailed = 0x12

  case temperature = 0x04
  case power = 0x05
  case database = 0x06
  case radioError = 0x07

  case wlanStart = 0x08
  case wlanStop = 0x09
  case wlanConnect = 0x10
  case wlanDisconnect = 0x11

  init(_ eventStatus: SRFID_EVENT_STATUS) {
    self.init(rawValue: eventStatus.rawValue)!
  }

  var srfidValue: SRFID_EVENT_STATUS {
    SRFID_EVENT_STATUS(self.rawValue)
  }
}

public enum RfidMemoryBank: UInt32, Equatable, Sendable, SRFIDConvertable {
  case epc = 0x01
  case tid = 0x02
  case user = 0x04
  case reserved = 0x08
  case none = 0x10
  case access = 0x20
  case kill = 0x40
  case tamper = 0x60
  case all = 0x67

  init(_ memoryBank: SRFID_MEMORYBANK) {
    self = RfidMemoryBank(rawValue: memoryBank.rawValue) ?? .none
  }

  var srfidValue: SRFID_MEMORYBANK {
    .init(rawValue: self.rawValue)
  }
}

public enum RfidAccessOperationCode: UInt32, Equatable, Sendable, SRFIDConvertable {
  case read = 0
  case write = 1
  case lock = 2
  case kill = 3
  case blockWrite = 4
  case blockErase = 5
  case recommission = 6
  case blockPermalock = 7
  case nxpSetEas = 8
  case nxpReadProtect = 9
  case nxpResetReadProtect = 10
  case impinjQtWrite = 20
  case impinjQtRead = 21
  case nxpChangeConfig = 22
  case none = 0xFF

  init(_ opCode: SRFID_ACCESSOPERATIONCODE) {
    self.init(rawValue: opCode.rawValue)!
  }

  var srfidValue: SRFID_ACCESSOPERATIONCODE {
    SRFID_ACCESSOPERATIONCODE(self.rawValue)
  }
}

public enum RfidDivideRatio: UInt32, Equatable, Sendable, SRFIDConvertable {
  case dr8 = 0
  case dr64_3 = 1

  init(_ ratio: SRFID_DIVIDERATIO) {
    self.init(rawValue: ratio.rawValue)!
  }

  var srfidValue: SRFID_DIVIDERATIO {
    SRFID_DIVIDERATIO(rawValue: self.rawValue)
  }
}

public enum RfidModulation: UInt32, Equatable, Sendable, SRFIDConvertable {
  case mv_fm0 = 0
  case mv_2 = 1
  case mv_4 = 2
  case mv_8 = 3

  init(_ modulation: SRFID_MODULATION) {
    self.init(rawValue: modulation.rawValue)!
  }

  var srfidValue: SRFID_MODULATION {
    SRFID_MODULATION(rawValue: self.rawValue)
  }
}

public enum RfidForwardLinkModulation: UInt32, Equatable, Sendable, SRFIDConvertable {
  case pr_ask = 0
  case ssb_ask = 1
  case dsb_ask = 2

  init(_ modulation: SRFID_FORWARDLINKMODULATION) {
    self.init(rawValue: modulation.rawValue)!
  }

  var srfidValue: SRFID_FORWARDLINKMODULATION {
    SRFID_FORWARDLINKMODULATION(rawValue: self.rawValue)
  }
}

public enum RfidSpectralMaskIndicator: UInt32, Equatable, Sendable, SRFIDConvertable {
  case si = 1
  case mi = 2
  case di = 3

  init(_ modulation: SRFID_SPECTRALMASKINDICATOR) {
    self.init(rawValue: modulation.rawValue)!
  }

  var srfidValue: SRFID_SPECTRALMASKINDICATOR {
    SRFID_SPECTRALMASKINDICATOR(rawValue: self.rawValue)
  }
}

public enum RfidSLFlag: UInt32, Sendable, SRFIDConvertable {
  case asserted = 0
  case deasserted = 1
  case all = 2

  init(_ slFlag: SRFID_SLFLAG) {
    self.init(rawValue: slFlag.rawValue)!
  }

  var srfidValue: SRFID_SLFLAG {
    SRFID_SLFLAG(self.rawValue)
  }
}

public enum RfidSession: UInt32, Sendable, SRFIDConvertable {
  case s0 = 0
  case s1 = 1
  case s2 = 2
  case s3 = 3

  init(_ session: SRFID_SESSION) {
    self.init(rawValue: session.rawValue)!
  }

  var srfidValue: SRFID_SESSION {
    SRFID_SESSION(self.rawValue)
  }
}

public enum RfidInventoryState: UInt32, Sendable, SRFIDConvertable {
  case a = 0
  case b = 1
  case abFlip = 2

  init(_ inventoryState: SRFID_INVENTORYSTATE) {
    self.init(rawValue: inventoryState.rawValue)!
  }

  var srfidValue: SRFID_INVENTORYSTATE {
    SRFID_INVENTORYSTATE(self.rawValue)
  }
}

public enum RfidTriggerType: UInt32, Sendable, SRFIDConvertable {
  case press = 0x00
  case release = 0x01

  init(_ triggerType: SRFID_TRIGGERTYPE) {
    self.init(rawValue: triggerType.rawValue)!
  }

  var srfidValue: SRFID_TRIGGERTYPE {
    SRFID_TRIGGERTYPE(self.rawValue)
  }
}

public enum RfidSelectTarget: UInt32, Sendable, SRFIDConvertable {
  case s0 = 0
  case s1 = 1
  case s2 = 2
  case s3 = 3
  case sl = 4

  init(_ selectTarget: SRFID_SELECTTARGET) {
    self.init(rawValue: selectTarget.rawValue)!
  }

  var srfidValue: SRFID_SELECTTARGET {
    SRFID_SELECTTARGET(self.rawValue)
  }
}

public enum RfidSelectAction: UInt32, Sendable, SRFIDConvertable {
  case invANotInvBOrAsrtSlNotDsrtSl = 0
  case invAOrAsrtSl = 1
  case notInvBOrNotDsrtSl = 2
  case invA2BB2ANotInvAOrNegSlNotAsrtSl = 3
  case invBNotInvAOrDsrtSlNotAsrtSl = 4
  case invBOrDsrtSl = 5
  case notInvAOrNotAsrtSl = 6
  case notInvA2BB2AOrNotNegSl = 7

  init(_ selectAction: SRFID_SELECTACTION) {
    self.init(rawValue: selectAction.rawValue)!
  }

  var srfidValue: SRFID_SELECTACTION {
    SRFID_SELECTACTION(self.rawValue)
  }
}

public enum RfidAccessPermission: UInt32, Equatable, Sendable, SRFIDConvertable {
  case accessible = 0
  case permanent = 1
  case secured = 2
  case alwaysNotAccessible = 3

  init(_ accessPermission: SRFID_ACCESSPERMISSION) {
    self.init(rawValue: accessPermission.rawValue)!
  }

  var srfidValue: SRFID_ACCESSPERMISSION {
    .init(rawValue: self.rawValue)
  }
}

public enum RfidBeeperConfig: UInt32, Sendable, SRFIDConvertable {
  case high = 0
  case medium = 1
  case low = 2
  case quiet = 3

  init(_ beeperConfig: SRFID_BEEPERCONFIG) {
    self.init(rawValue: beeperConfig.rawValue)!
  }

  var srfidValue: SRFID_BEEPERCONFIG {
    SRFID_BEEPERCONFIG(self.rawValue)
  }
}

public enum RfidTriggerEvent: UInt32, Sendable, SRFIDConvertable {
  case pressed = 0
  case released = 1
  case scanPressed = 2
  case scanReleased = 3

  init(_ event: SRFID_TRIGGEREVENT) {
    self.init(rawValue: event.rawValue)!
  }

  var srfidValue: SRFID_TRIGGEREVENT {
    SRFID_TRIGGEREVENT(self.rawValue)
  }
}

public enum RfidHoppingConfig: UInt32, Sendable, SRFIDConvertable {
  case `default` = 0
  case enabled = 1
  case disabled = 2

  init(_ hoppingConfig: SRFID_HOPPINGCONFIG) {
    self.init(rawValue: hoppingConfig.rawValue)!
  }

  var srfidValue: SRFID_HOPPINGCONFIG {
    SRFID_HOPPINGCONFIG(self.rawValue)
  }
}

public enum RfidBatchModeConfig: UInt32, Sendable, SRFIDConvertable {
  case disable = 0
  case auto = 1
  case enable = 2

  init(_ batchConfig: SRFID_BATCHMODECONFIG) {
    self.init(rawValue: batchConfig.rawValue)!
  }

  var srfidValue: SRFID_BATCHMODECONFIG {
    SRFID_BATCHMODECONFIG(self.rawValue)
  }
}

public struct RfidReaderInfo: Identifiable, Equatable, Sendable, SRFIDConvertable {
  public let id: Int32
  public let connectionType: RfidConnectionType
  public let isActive: Bool
  public let name: String
  public let model: Int32

  public init(
    id: Int32,
    connectionType: RfidConnectionType,
    isActive: Bool,
    name: String,
    model: Int32
  ) {
    self.id = id
    self.connectionType = connectionType
    self.isActive = isActive
    self.name = name
    self.model = model
  }

  init(_ readerInfo: srfidReaderInfo) {
    self.id = readerInfo.getReaderID()
    self.connectionType = .init(rawValue: readerInfo.getConnectionType()) ?? .invalid
    self.isActive = readerInfo.isActive()
    self.name = readerInfo.getReaderName()
    self.model = readerInfo.getReaderModel()
  }

  var srfidValue: srfidReaderInfo {
    let reader = srfidReaderInfo()!
    reader.setReaderID(id)
    reader.setConnectionType(connectionType.rawValue)
    reader.setActive(isActive)
    reader.setReaderName(name)
    reader.setReaderModel(model)
    return reader
  }
}

public struct RfidTagData: Identifiable, Equatable, Sendable, SRFIDConvertable {
  public let epc: String
  public let firstSeenTime: Int
  public let lastSeenTime: Int
  public let pc: String
  public let peakRSSI: Int16
  public let phaseInfo: Int16
  public let channelIndex: Int16
  public let seenCount: Int16
  public let accessOperationCode: RfidNamedAccessOperationCode?
  public let operationSucceeded: Bool
  public let operationStatus: String
  public let memoryBank: RfidMemoryBank?
  public let memoryBankData: String
  public let permaLockData: String
  public let modifiedWordCount: Int32
  public let g2v2Result: String
  public let g2v2Response: String
  public let brandIDStatusData: Bool
  public let proximity: Int32

  public var id: String {
    epc
  }

  public init(
    epc: String,
    firstSeenTime: Int,
    lastSeenTime: Int,
    pc: String,
    peakRSSI: Int16,
    phaseInfo: Int16,
    channelIndex: Int16,
    seenCount: Int16,
    accessOperationCode: RfidNamedAccessOperationCode?,
    operationSucceeded: Bool,
    operationStatus: String,
    memoryBank: RfidMemoryBank?,
    memoryBankData: String,
    permaLockData: String,
    modifiedWordCount: Int32,
    g2v2Result: String,
    g2v2Response: String,
    brandIDStatusData: Bool,
    proximity: Int32
  ) {
    self.epc = epc
    self.firstSeenTime = firstSeenTime
    self.lastSeenTime = lastSeenTime
    self.pc = pc
    self.peakRSSI = peakRSSI
    self.phaseInfo = phaseInfo
    self.channelIndex = channelIndex
    self.seenCount = seenCount
    self.accessOperationCode = accessOperationCode
    self.operationSucceeded = operationSucceeded
    self.operationStatus = operationStatus
    self.memoryBank = memoryBank
    self.memoryBankData = memoryBankData
    self.permaLockData = permaLockData
    self.modifiedWordCount = modifiedWordCount
    self.g2v2Result = g2v2Result
    self.g2v2Response = g2v2Response
    self.brandIDStatusData = brandIDStatusData
    self.proximity = proximity
  }

  init(_ tagData: srfidTagData) {
    self.epc = tagData.getTagId()
    self.firstSeenTime = tagData.getFirstSeenTime()
    self.lastSeenTime = tagData.getLastSeenTime()
    self.pc = tagData.getPC()
    self.peakRSSI = tagData.getPeakRSSI()
    self.phaseInfo = tagData.getPhaseInfo()
    self.channelIndex = tagData.getChannelIndex()
    self.seenCount = tagData.getTagSeenCount()
    self.accessOperationCode = tagData.getOpCode().map(RfidNamedAccessOperationCode.init(_:))
    self.operationSucceeded = tagData.getOperationSucceed()
    self.operationStatus = tagData.getOperationStatus()
    self.memoryBank = .init(tagData.getMemoryBank())
    self.memoryBankData = tagData.getMemoryBankData()
    self.permaLockData = tagData.getPermaLock()
    self.modifiedWordCount = tagData.getModifiedWordCount()
    self.g2v2Result = tagData.getg2v2Result()
    self.g2v2Response = tagData.getg2v2Response()
    self.brandIDStatusData = tagData.getBrandIDStatusRfidTagData()
    self.proximity = tagData.getProximity()
  }

  var srfidValue: srfidTagData {
    let tag = srfidTagData()
    tag.setTagId(epc)
    tag.setFirstSeenTime(firstSeenTime)
    tag.setLastSeenTime(lastSeenTime)
    tag.setPC(pc)
    tag.setPeakRSSI(peakRSSI)
    tag.setPhaseInfo(phaseInfo)
    tag.setChannelIndex(channelIndex)
    tag.setTagSeenCount(seenCount)
    if let accessOperationCode {
      tag.setOpCode(accessOperationCode.srfidValue)
    }
    tag.setOperationSucceed(operationSucceeded)
    tag.setOperationStatus(operationStatus)
    if let memoryBank {
      tag.setMemoryBank(memoryBank.srfidValue)
    }
    tag.setMemoryBank(memoryBankData)
    tag.setPermaLock(permaLockData)
    tag.setModifiedWordCount(modifiedWordCount)
    tag.setg2v2Result(g2v2Result)
    tag.setg2v2Response(g2v2Response)
    tag.setBrandIDStatusRfid(brandIDStatusData)
    tag.setProximity(proximity)
    return tag
  }
}

public struct RfidTagFilter: Equatable, Sendable, SRFIDConvertable {
  public let memoryBank: RfidMemoryBank
  public let startPosition: Int16
  public let data: String
  public let mask: String
  public let matchLength: Int16
  public let doMatch: Bool

  init(
    memoryBank: RfidMemoryBank,
    startPosition: Int16,
    data: String,
    mask: String,
    matchLength: Int16,
    doMatch: Bool
  ) {
    self.memoryBank = memoryBank
    self.startPosition = startPosition
    self.data = data
    self.mask = mask
    self.matchLength = matchLength
    self.doMatch = doMatch
  }

  init(_ tagFilter: srfidTagFilter) {
    memoryBank = .init(tagFilter.getMaskBank())
    startPosition = tagFilter.getMaskStartPos()
    data = tagFilter.getData()
    mask = tagFilter.getMask()
    matchLength = tagFilter.getMatchLength()
    doMatch = tagFilter.getDoMatch()
  }

  var srfidValue: srfidTagFilter {
    let tagFilter = srfidTagFilter()
    tagFilter.setFilterMaskBank(memoryBank.srfidValue)
    tagFilter.setFilterMaskStartPos(startPosition)
    tagFilter.setFilterData(data)
    tagFilter.setFilterMask(mask)
    tagFilter.setFilterMatchLength(matchLength)
    tagFilter.setFilterDoMatch(doMatch)
    return tagFilter
  }
}

public struct RfidNamedAccessOperationCode: Equatable, Sendable, SRFIDConvertable {
  public let name: String
  public let operationCode: RfidAccessOperationCode

  public init(name: String, operationCode: RfidAccessOperationCode) {
    self.name = name
    self.operationCode = operationCode
  }

  init(_ opCode: srfidAccessOperationCode) {
    self.name = opCode.getName()
    self.operationCode = .init(opCode.getOrdinal())
  }

  var srfidValue: srfidAccessOperationCode {
    return srfidAccessOperationCode(
      accessOperationCode: name,
      aOrdinal: operationCode.srfidValue
    )
  }
}

public struct RfidAccessConfig: Equatable, Sendable, SRFIDConvertable {
  public let select: Bool
  public let power: Int16

  public init(select: Bool, power: Int16) {
    self.select = select
    self.power = power
  }

  init(_ accessConfig: srfidAccessConfig) {
    select = accessConfig.getDoSelect()
    power = accessConfig.getPower()
  }

  var srfidValue: srfidAccessConfig {
    let accessConfig = srfidAccessConfig()
    accessConfig.setDoSelect(select)
    accessConfig.setPower(power)
    return accessConfig
  }
}

public struct RfidAccessCriteria: Equatable, Sendable, SRFIDConvertable {
  public let tagFilter1: RfidTagFilter?
  public let tagFilter2: RfidTagFilter?

  init(tagFilter1: RfidTagFilter? = nil, tagFilter2: RfidTagFilter? = nil) {
    self.tagFilter1 = tagFilter1
    self.tagFilter2 = tagFilter2
  }

  init(_ accessCriteria: srfidAccessCriteria) {
    tagFilter1 = accessCriteria.tagFilter1.map { RfidTagFilter($0) }
    tagFilter2 = accessCriteria.tagFilter2.map { RfidTagFilter($0) }
  }

  var srfidValue: srfidAccessCriteria {
    let accessCriteria = srfidAccessCriteria()
    accessCriteria.tagFilter1 = tagFilter1?.srfidValue
    accessCriteria.tagFilter2 = tagFilter2?.srfidValue
    return accessCriteria
  }
}

public struct RfidReportConfig: Equatable, Sendable, SRFIDConvertable {
  public let firstSeenTime: Bool
  public let lastSeenTime: Bool
  public let pc: Bool
  public let rssi: Bool
  public let phase: Bool
  public let channelIndex: Bool
  public let seenCount: Bool

  public init(
    firstSeenTime: Bool = false,
    lastSeenTime: Bool = false,
    pc: Bool = false,
    rssi: Bool = false,
    phase: Bool = false,
    channelIndex: Bool = false,
    seenCount: Bool = false
  ) {
    self.firstSeenTime = firstSeenTime
    self.lastSeenTime = lastSeenTime
    self.pc = pc
    self.rssi = rssi
    self.phase = phase
    self.channelIndex = channelIndex
    self.seenCount = seenCount
  }

  init(_ reportConfig: srfidReportConfig) {
    firstSeenTime = reportConfig.getIncFirstSeenTime()
    lastSeenTime = reportConfig.getIncLastSeenTime()
    pc = reportConfig.getIncPC()
    rssi = reportConfig.getIncRSSI()
    phase = reportConfig.getIncPhase()
    channelIndex = reportConfig.getIncChannelIndex()
    seenCount = reportConfig.getIncTagSeenCount()
  }

  var srfidValue: srfidReportConfig {
    let reportConfig = srfidReportConfig()
    reportConfig.setIncFirstSeenTime(firstSeenTime)
    reportConfig.setIncLastSeenTime(lastSeenTime)
    reportConfig.setIncPC(pc)
    reportConfig.setIncRSSI(rssi)
    reportConfig.setIncPhase(phase)
    reportConfig.setIncChannelIndex(channelIndex)
    reportConfig.setIncTagSeenCount(seenCount)
    return reportConfig
  }
}

public struct RfidSingulationConfig: Equatable, Sendable, SRFIDConvertable {
  public let slFlag: RfidSLFlag
  public let session: RfidSession
  public let inventoryState: RfidInventoryState
  public let tagPopulation: Int32

  init(
    slFlag: RfidSLFlag,
    session: RfidSession,
    inventoryState: RfidInventoryState,
    tagPopulation: Int32
  ) {
    self.slFlag = slFlag
    self.session = session
    self.inventoryState = inventoryState
    self.tagPopulation = tagPopulation
  }

  init(_ singulationConfig: srfidSingulationConfig) {
    slFlag = .init(singulationConfig.getSLFlag())
    session = .init(singulationConfig.getSession())
    inventoryState = .init(singulationConfig.getInventoryState())
    tagPopulation = singulationConfig.getTagPopulation()
  }

  var srfidValue: srfidSingulationConfig {
    let config = srfidSingulationConfig()
    config.setSlFlag(slFlag.srfidValue)
    config.setSession(session.srfidValue)
    config.setInventoryState(inventoryState.srfidValue)
    config.setTagPopulation(tagPopulation)
    return config
  }
}

public struct RfidLinkProfile: Equatable, Sendable, SRFIDConvertable {
  public let rfModeIndex: Int32
  public let divideRatio: RfidDivideRatio
  public let bdr: Int32
  public let modulation: RfidModulation
  public let forwardLinkModulation: RfidForwardLinkModulation
  public let pie: Int32
  public let tariMin: Int32
  public let tariMax: Int32
  public let tariStep: Int32
  public let spectralMaskIndicator: RfidSpectralMaskIndicator
  public let epchagtacConformance: Bool

  public init(
    rfModeIndex: Int32,
    divideRatio: RfidDivideRatio,
    bdr: Int32,
    modulation: RfidModulation,
    forwardLinkModulation: RfidForwardLinkModulation,
    pie: Int32,
    tariMin: Int32,
    tariMax: Int32,
    tariStep: Int32,
    spectralMaskIndicator: RfidSpectralMaskIndicator,
    epchagtacConformance: Bool
  ) {
    self.rfModeIndex = rfModeIndex
    self.divideRatio = divideRatio
    self.bdr = bdr
    self.modulation = modulation
    self.forwardLinkModulation = forwardLinkModulation
    self.pie = pie
    self.tariMin = tariMin
    self.tariMax = tariMax
    self.tariStep = tariStep
    self.spectralMaskIndicator = spectralMaskIndicator
    self.epchagtacConformance = epchagtacConformance
  }

  init(_ linkProfile: srfidLinkProfile) {
    rfModeIndex = linkProfile.getRFModeIndex()
    divideRatio = .init(linkProfile.getDivideRatio())
    bdr = linkProfile.getBDR()
    modulation = .init(linkProfile.getModulation())
    forwardLinkModulation = .init(linkProfile.getFLModulation())
    pie = linkProfile.getPIE()
    tariMin = linkProfile.getMinTari()
    tariMax = linkProfile.getMaxTari()
    tariStep = linkProfile.getStepTari()
    spectralMaskIndicator = .init(linkProfile.getSpectralMaskIndicator())
    epchagtacConformance = linkProfile.getEPCHAGTCConformance()
  }

  var srfidValue: srfidLinkProfile {
    let linkProfile = srfidLinkProfile()
    linkProfile.setRFModeIndex(rfModeIndex)
    linkProfile.setDivide(divideRatio.srfidValue)
    linkProfile.setBDR(bdr)
    linkProfile.setModulation(modulation.srfidValue)
    linkProfile.setFLModulation(forwardLinkModulation.srfidValue)
    linkProfile.setPIE(pie)
    linkProfile.setMinTari(tariMin)
    linkProfile.setMaxTari(tariMax)
    linkProfile.setStepTari(tariStep)
    linkProfile.setSpectralMaskIndicator(spectralMaskIndicator.srfidValue)
    linkProfile.setEPCHAGTCConformance(epchagtacConformance)
    return linkProfile
  }
}

public struct RfidAntennaConfig: Equatable, Sendable, SRFIDConvertable {
  public let power: Int16
  public let linkProfileIndex: Int16
  public let tari: Int32
  public let select: Bool

  public init(
    power: Int16,
    linkProfileIndex: Int16,
    tari: Int32,
    select: Bool
  ) {
    self.power = power
    self.linkProfileIndex = linkProfileIndex
    self.tari = tari
    self.select = select
  }

  init(_ antennaConfig: srfidAntennaConfiguration) {
    power = antennaConfig.getPower()
    linkProfileIndex = antennaConfig.getLinkProfileIdx()
    tari = antennaConfig.getTari()
    select = antennaConfig.getDoSelect()
  }

  var srfidValue: srfidAntennaConfiguration {
    let antennaConfig = srfidAntennaConfiguration()
    antennaConfig.setPower(power)
    antennaConfig.setLinkProfileIdx(linkProfileIndex)
    antennaConfig.setTari(tari)
    antennaConfig.setDoSelect(select)
    return antennaConfig
  }
}

public struct RfidDynamicPowerConfig: Equatable, Sendable, SRFIDConvertable {
  public let powerOptimizationEnabled: Bool

  public init(powerOptimizationEnabled: Bool) {
    self.powerOptimizationEnabled = powerOptimizationEnabled
  }

  init(_ dpoConfig: srfidDynamicPowerConfig) {
    powerOptimizationEnabled = dpoConfig.getDynamicPowerOptimizationEnabled()
  }

  var srfidValue: srfidDynamicPowerConfig {
    let dpoConfig = srfidDynamicPowerConfig()
    dpoConfig.setDynamicPowerOptimizationEnabled(powerOptimizationEnabled)
    return dpoConfig
  }
}

public struct RfidTagReportConfig: Equatable, Sendable, SRFIDConvertable {
  public let firstSeenTime: Bool
  public let lastSeenTime: Bool
  public let pc: Bool
  public let rssi: Bool
  public let phase: Bool
  public let channelIndex: Bool
  public let seenCount: Bool

  public init(
    firstSeenTime: Bool = false,
    lastSeenTime: Bool = false,
    pc: Bool = false,
    rssi: Bool = false,
    phase: Bool = false,
    channelIndex: Bool = false,
    seenCount: Bool = false
  ) {
    self.firstSeenTime = firstSeenTime
    self.lastSeenTime = lastSeenTime
    self.pc = pc
    self.rssi = rssi
    self.phase = phase
    self.channelIndex = channelIndex
    self.seenCount = seenCount
  }

  init(_ reportConfig: srfidTagReportConfig) {
    firstSeenTime = reportConfig.getIncFirstSeenTime()
    lastSeenTime = reportConfig.getIncLastSeenTime()
    pc = reportConfig.getIncPC()
    rssi = reportConfig.getIncRSSI()
    phase = reportConfig.getIncPhase()
    channelIndex = reportConfig.getIncChannelIdx()
    seenCount = reportConfig.getIncTagSeenCount()
  }

  var srfidValue: srfidTagReportConfig {
    let reportConfig = srfidTagReportConfig()
    reportConfig.setIncFirstSeenTime(firstSeenTime)
    reportConfig.setIncLastSeenTime(lastSeenTime)
    reportConfig.setIncPC(pc)
    reportConfig.setIncRSSI(rssi)
    reportConfig.setIncPhase(phase)
    reportConfig.setIncChannelIdx(channelIndex)
    reportConfig.setIncTagSeenCount(seenCount)
    return reportConfig
  }
}

public struct RfidStartTriggerConfig: Equatable, Sendable, SRFIDConvertable {
  public let triggerType: RfidTriggerType?
  public let startDelay: UInt32?
  public let repeatMonitoring: Bool?

  public init(
    triggerType: RfidTriggerType?,
    startDelay: UInt32? = nil,
    repeatMonitoring: Bool? = nil
  ) {
    self.triggerType = triggerType
    self.startDelay = startDelay
    self.repeatMonitoring = repeatMonitoring
  }

  init(_ startTriggerConfig: srfidStartTriggerConfig) {
    if startTriggerConfig.getStartOnHandheldTrigger() {
      triggerType = .init(startTriggerConfig.getTriggerType())
      startDelay = startTriggerConfig.getStartDelay()
      repeatMonitoring = startTriggerConfig.getRepeatMonitoring()
    } else {
      triggerType = nil
      startDelay = nil
      repeatMonitoring = nil
    }
  }

  var srfidValue: srfidStartTriggerConfig {
    let startTriggerConfig = srfidStartTriggerConfig()
    guard let triggerType else {
      return startTriggerConfig
    }
    startTriggerConfig.setStartOnHandheldTrigger(true)
    startTriggerConfig.setTriggerType(triggerType.srfidValue)
    if let startDelay {
      startTriggerConfig.setStartDelay(startDelay)
    }
    if let repeatMonitoring {
      startTriggerConfig.setRepeatMonitoring(repeatMonitoring)
    }
    return startTriggerConfig
  }
}

public struct RfidStopTriggerConfig: Equatable, Sendable, SRFIDConvertable {
  public let triggerType: RfidTriggerType?
  public let tagCount: UInt32?
  public let timeout: UInt32?
  public let inventoryCount: UInt32?
  public let accessCount: UInt32?

  public init(
    triggerType: RfidTriggerType?,
    tagCount: UInt32? = nil,
    timeout: UInt32? = nil,
    inventoryCount: UInt32? = nil,
    accessCount: UInt32? = nil
  ) {
    self.triggerType = triggerType
    self.tagCount = tagCount
    self.timeout = timeout
    self.inventoryCount = inventoryCount
    self.accessCount = accessCount
  }

  init(_ stopTriggerConfig: srfidStopTriggerConfig) {
    if stopTriggerConfig.getStopOnHandheldTrigger() {
      triggerType = .init(stopTriggerConfig.getTriggerType())
      tagCount = stopTriggerConfig.getStopOnTagCount() ? stopTriggerConfig.getStopTagCount() : nil
      timeout = stopTriggerConfig.getStopOnTimeout() ? stopTriggerConfig.getStopTimeout() : nil
      inventoryCount =
        stopTriggerConfig.getStopOnInventoryCount()
        ? stopTriggerConfig.getStopInventoryCount() : nil
      accessCount =
        stopTriggerConfig.getStopOnAccessCount() ? stopTriggerConfig.getStopAccessCount() : nil
    } else {
      triggerType = nil
      tagCount = nil
      timeout = nil
      inventoryCount = nil
      accessCount = nil
    }
  }

  var srfidValue: srfidStopTriggerConfig {
    let stopConfig = srfidStopTriggerConfig()
    guard let triggerType else {
      return stopConfig
    }
    stopConfig.setTriggerType(triggerType.srfidValue)
    if let tagCount {
      stopConfig.setStopOnTagCount(true)
      stopConfig.setStopTagCount(tagCount)
    }
    if let timeout {
      stopConfig.setStopOnTimeout(true)
      stopConfig.setStopTimout(timeout)
    }
    if let inventoryCount {
      stopConfig.setStopOnInventoryCount(true)
      stopConfig.setStopInventoryCount(inventoryCount)
    }
    if let accessCount {
      stopConfig.setStopOnAccessCount(true)
      stopConfig.setStopAccessCount(accessCount)
    }
    return stopConfig
  }
}

public struct RfidReaderVersionInfo: Equatable, Sendable, SRFIDConvertable {
  public let deviceVersion: String
  public let bluetoothVersion: String
  public let ngeVersion: String
  public let pl33Version: String

  public init(
    deviceVersion: String,
    bluetoothVersion: String,
    ngeVersion: String,
    pl33Version: String
  ) {
    self.deviceVersion = deviceVersion
    self.bluetoothVersion = bluetoothVersion
    self.ngeVersion = ngeVersion
    self.pl33Version = pl33Version
  }

  init(_ versionInfo: srfidReaderVersionInfo) {
    deviceVersion = versionInfo.getDeviceVersion()
    bluetoothVersion = versionInfo.getBluetoothVersion()
    ngeVersion = versionInfo.getNGEVersion()
    pl33Version = versionInfo.getPL33()
  }

  var srfidValue: srfidReaderVersionInfo {
    let version = srfidReaderVersionInfo()
    version.setReaderDeviceVersion(deviceVersion)
    version.setBluetoothVersion(bluetoothVersion)
    version.setNGEVersion(ngeVersion)
    version.setPL33(pl33Version)
    return version
  }
}

public struct RfidSupportedRegion: Equatable, Sendable, SRFIDConvertable {
  public let code: String
  public let name: String

  public init(code: String, name: String) {
    self.code = code
    self.name = name
  }

  init(_ region: srfidRegionInfo) {
    code = region.getRegionCode()
    name = region.getRegionName()
  }

  var srfidValue: srfidRegionInfo {
    let region = srfidRegionInfo()
    region.setRegionCode(code)
    region.setRegionName(name)
    return region
  }
}

public struct RfidRegionInfo: Equatable, Sendable {
  public let supportedChannels: [String]
  public let hoppingConfigurable: Bool

  public init(supportedChannels: [String], hoppingConfigurable: Bool) {
    self.supportedChannels = supportedChannels
    self.hoppingConfigurable = hoppingConfigurable
  }
}

public struct RfidRegulatoryConfig: Equatable, Sendable, SRFIDConvertable {
  public let regionCode: String
  public let enabledChannelsList: [String]
  public let hoppingConfig: RfidHoppingConfig

  public init(
    regionCode: String,
    enabledChannelsList: [String],
    hoppingConfig: RfidHoppingConfig
  ) {
    self.regionCode = regionCode
    self.enabledChannelsList = enabledChannelsList
    self.hoppingConfig = hoppingConfig
  }

  init(_ regulatoryConfig: srfidRegulatoryConfig) {
    regionCode = regulatoryConfig.getRegionCode()
    enabledChannelsList = regulatoryConfig.getEnabledChannelsList().compactMap { $0 as? String }
    hoppingConfig = .init(regulatoryConfig.getHoppingConfig())
  }

  var srfidValue: srfidRegulatoryConfig {
    let config = srfidRegulatoryConfig()
    config.setRegionCode(regionCode)
    config.setEnabledChannelsList(enabledChannelsList)
    config.setHopping(hoppingConfig.srfidValue)
    return config
  }
}

public struct RfidPreFilter: Equatable, Sendable, SRFIDConvertable {
  public let target: RfidSelectTarget
  public let action: RfidSelectAction
  public let memoryBank: RfidMemoryBank
  public let maskStartPosition: Int32
  public let matchPattern: String

  init(
    target: RfidSelectTarget,
    action: RfidSelectAction,
    memoryBank: RfidMemoryBank,
    maskStartPosition: Int32,
    matchPattern: String
  ) {
    self.target = target
    self.action = action
    self.memoryBank = memoryBank
    self.maskStartPosition = maskStartPosition
    self.matchPattern = matchPattern
  }

  init(_ preFilter: srfidPreFilter) {
    target = .init(preFilter.getTarget())
    action = .init(preFilter.getAction())
    memoryBank = .init(preFilter.getMemoryBank())
    maskStartPosition = preFilter.getMaskStartPos()
    matchPattern = preFilter.getMatchPattern()
  }

  var srfidValue: srfidPreFilter {
    let preFilter = srfidPreFilter()
    preFilter.setTarget(target.srfidValue)
    preFilter.setAction(action.srfidValue)
    preFilter.setMemoryBank(memoryBank.srfidValue)
    preFilter.setMaskStartPos(maskStartPosition)
    preFilter.setMatchPattern(matchPattern)
    return preFilter
  }
}

public struct RfidReaderCapabilitiesInfo: Equatable, Sendable, SRFIDConvertable {
  public let serialNumber: String
  public let model: String
  public let manufacturer: String
  public let manufacturingDate: String
  public let scannerName: String
  public let asciiVersion: String
  public let selectFilterNum: Int32
  public let powerMin: Int32
  public let powerMax: Int32
  public let powerStep: Int32
  public let airProtocolVersion: String
  public let bdAddress: String
  public let maxAccessSequence: Int32

  public init(
    serialNumber: String,
    model: String,
    manufacturer: String,
    manufacturingDate: String,
    scannerName: String,
    asciiVersion: String,
    selectFilterNum: Int32,
    powerMin: Int32,
    powerMax: Int32,
    powerStep: Int32,
    airProtocolVersion: String,
    bdAddress: String,
    maxAccessSequence: Int32
  ) {
    self.serialNumber = serialNumber
    self.model = model
    self.manufacturer = manufacturer
    self.manufacturingDate = manufacturingDate
    self.scannerName = scannerName
    self.asciiVersion = asciiVersion
    self.selectFilterNum = selectFilterNum
    self.powerMin = powerMin
    self.powerMax = powerMax
    self.powerStep = powerStep
    self.airProtocolVersion = airProtocolVersion
    self.bdAddress = bdAddress
    self.maxAccessSequence = maxAccessSequence
  }

  init(_ readerInfo: srfidReaderCapabilitiesInfo) {
    serialNumber = readerInfo.getSerialNumber()
    model = readerInfo.getModel()
    manufacturer = readerInfo.getManufacturer()
    manufacturingDate = readerInfo.getManufacturingDate()
    scannerName = readerInfo.getScannerName()
    asciiVersion = readerInfo.getAsciiVersion()
    selectFilterNum = readerInfo.getSelectFilterNum()
    powerMin = readerInfo.getMinPower()
    powerMax = readerInfo.getMaxPower()
    powerStep = readerInfo.getPowerStep()
    airProtocolVersion = readerInfo.getAirProtocolVersion()
    bdAddress = readerInfo.getBDAddress()
    maxAccessSequence = readerInfo.getMaxAccessSequence()
  }

  var srfidValue: srfidReaderCapabilitiesInfo {
    let readerInfo = srfidReaderCapabilitiesInfo()
    readerInfo.setReaderSerialNumber(serialNumber)
    readerInfo.setModel(model)
    readerInfo.setManufacturer(manufacturer)
    readerInfo.setManufacturingDate(manufacturingDate)
    readerInfo.setScannerName(scannerName)
    readerInfo.setAsciiVersion(asciiVersion)
    readerInfo.setSelectFilterNum(selectFilterNum)
    readerInfo.setMinPower(powerMin)
    readerInfo.setMaxPower(powerMax)
    readerInfo.setPowerStep(powerStep)
    readerInfo.setAirProtocolVersion(airProtocolVersion)
    readerInfo.setBDAddress(bdAddress)
    readerInfo.setMaxAccessSequence(maxAccessSequence)
    return readerInfo
  }
}

public struct RfidBatteryEvent: Equatable, Sendable, SRFIDConvertable {
  public let powerLevel: Int32
  public let isCharging: Bool
  public let eventCause: String

  public init(powerLevel: Int32, isCharging: Bool, eventCause: String) {
    self.powerLevel = powerLevel
    self.isCharging = isCharging
    self.eventCause = eventCause
  }

  init(_ event: srfidBatteryEvent) {
    self.powerLevel = event.getPowerLevel()
    self.isCharging = event.getIsCharging()
    self.eventCause = event.getCause()
  }

  var srfidValue: srfidBatteryEvent {
    let event = srfidBatteryEvent()
    event.setPowerLevel(powerLevel)
    event.setIsCharging(isCharging)
    event.setEventCause(eventCause)
    return event
  }
}

public struct RfidOperEndSummaryEvent: Equatable, Sendable, SRFIDConvertable {
  public let timeUs: Int
  public let tags: Int32
  public let rounds: Int32

  public init(timeUs: Int, tags: Int32, rounds: Int32) {
    self.timeUs = timeUs
    self.tags = tags
    self.rounds = rounds
  }

  init(_ event: srfidOperEndSummaryEvent) {
    timeUs = event.getTotalTimeUs()
    tags = event.getTotalTags()
    rounds = event.getTotalRounds()
  }

  var srfidValue: srfidOperEndSummaryEvent {
    let event = srfidOperEndSummaryEvent()
    event.setTotalTimeUs(timeUs)
    event.setTotalTags(tags)
    event.setTotalRounds(rounds)
    return event
  }
}

public struct RfidAttribute: Equatable, Sendable, SRFIDConvertable {
  public let attributeType: String
  public let number: Int32
  public let value: String
  public let offset: Int32
  public let propertyValue: Int32
  public let length: Int32

  public init(
    attributeType: String,
    number: Int32,
    value: String,
    offset: Int32,
    propertyValue: Int32,
    length: Int32
  ) {
    self.attributeType = attributeType
    self.number = number
    self.value = value
    self.offset = offset
    self.propertyValue = propertyValue
    self.length = length
  }

  init(_ attribute: srfidAttribute) {
    attributeType = attribute.getAttrType()
    number = attribute.getAttrNum()
    value = attribute.getAttrVal()
    offset = attribute.getOffset()
    propertyValue = attribute.getPropertyVal()
    length = attribute.getLength()
  }

  var srfidValue: srfidAttribute {
    let attribute = srfidAttribute()
    attribute.setAttrType(attributeType)
    attribute.setAttrNum(number)
    attribute.setAttrVal(value)
    attribute.setOffset(offset)
    attribute.setPropertyVal(propertyValue)
    attribute.setLength(length)
    return attribute
  }
}

public struct RfidWlanScanEntry: Equatable, Sendable, SRFIDConvertable {
  public let ssid: String
  public let wlanProtocol: String
  public let level: String
  public let macAddress: String

  public init(ssid: String, wlanProtocol: String, level: String, macAddress: String) {
    self.ssid = ssid
    self.wlanProtocol = wlanProtocol
    self.level = level
    self.macAddress = macAddress
  }

  init(_ entry: srfidWlanScanList) {
    self.ssid = entry.getWlanSSID()
    self.wlanProtocol = entry.getWlanProtocol()
    self.level = entry.getWlanLevel()
    self.macAddress = entry.getWlanMacAddress()
  }

  var srfidValue: srfidWlanScanList {
    let scanList = srfidWlanScanList()
    scanList.setWlanSSID(ssid)
    scanList.setWlanProtocol(wlanProtocol)
    scanList.setWlanLevel(level)
    scanList.setWlanMacAddress(macAddress)
    return scanList
  }
}
