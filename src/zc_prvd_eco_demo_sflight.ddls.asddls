@EndUserText.label: 'Provide ECO - SFLIGHT Consumption CDS'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity ZC_PRVD_ECO_DEMO_SFLIGHT
    as projection on ZIC_PRVD_ECO_DEMO_SFLIGHT as Flight
{
    key CarrierID,
    key ConnectionID,
    key FlightDate,
    PlaneType,
    MaxSeatsEconomy,
    MaxSeatsBusinessClass,
    MaxSeatsFirstClass,
    Currency,
    OccupiedEconomy,
    OccupiedBusinessClass,
    OccupiedFirstClass,
    Sflight_ID,
    CarbonAmount,
    CarbonUom,
    hasCarbonAggregate,
    hasAtomicOffset,
    hasPoAO,
    RetirementPageURL,
    //ShuttleURL,
    //carbAggCrit,
    //aoCrit,
    //poaoCrit,
    /* Associations */
    //_AtomicOffset,
    _CarbonAggregate
    //_CarbonRetirement    
    
    //case hasCarbonAggregate
    //   when  'X' then 3
    //   when  'W' then 2
    //   when others
    //end as aggr_criticality
    
}
