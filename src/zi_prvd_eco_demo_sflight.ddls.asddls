@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Provide ECO - SFLIGHT Demo CDS'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_PRVD_ECO_DEMO_SFLIGHT as select from sflight as Flight
    association[0..1] to ZI_PRVD_ECO_CA_2010 as _CarbonAggregate on _CarbonAggregate.AggregateId = $projection.Sflight_ID
    association[0..*] to ZI_PRVD_ECO_AO_4010 as _AtomicOffset on _AtomicOffset.AggregateId = $projection.Sflight_ID 
    association[0..1] to ZI_PRVD_ECO_AO_4401 as _AOAggregate on _AOAggregate.AggregateId = $projection.Sflight_ID
    association[0..1] to ZI_PRVD_ECO_POAO_4402 as _PoAOAggregate on _PoAOAggregate.AggregateId = $projection.Sflight_ID
    association[0..1] to ZI_PRVD_ECO_CA_2401 as _CarbonAggregateCount on _CarbonAggregateCount.AggregateId = $projection.Sflight_ID
                                                                      and _CarbonAggregateCount.ObjectID = $projection.Sflight_ID
                                                                      and _CarbonAggregateCount.ObjectType = 'SFLIGHT'
    association[0..*] to ZI_PRVD_ECO_CR_3030 as _CarbonRetirement on _CarbonRetirement.CarbonAggregateID = $projection.Sflight_ID 
{
    key Flight.carrid as CarrierID,
    key Flight.connid as ConnectionID,
    key Flight.fldate as FlightDate,
    Flight.planetype as PlaneType,
    Flight.seatsmax as MaxSeatsEconomy,
    Flight.seatsmax_b as MaxSeatsBusinessClass,
    Flight.seatsmax_f as MaxSeatsFirstClass,
    Flight.currency as Currency,
    //Flight.price as Price,
    //Flight.paymentsum as TotalPayments,
    Flight.seatsocc as OccupiedEconomy,
    Flight.seatsocc_b as OccupiedBusinessClass,
    Flight.seatsocc_f as OccupiedFirstClass,
    concat( Flight.carrid, concat('|', concat(Flight.connid, concat('|', Flight.fldate ) ) ) )  as Sflight_ID,

    
    
    //case atomicOffset.AggregateId
    //    when '' then ''
    //    else 'X'
    //end as hasAtomicOffset,
    _CarbonAggregateCount,
    //_CarbonAggregateCount.counter as CarbonAggregateCount,

        
    _CarbonAggregate,
    _AtomicOffset,
    _AOAggregate,
    _PoAOAggregate,
    _CarbonRetirement
    
}
