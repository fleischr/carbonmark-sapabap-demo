@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Provide ECO - SFLIGHT composite view'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZIC_PRVD_ECO_DEMO_SFLIGHT
  as select from ZI_PRVD_ECO_DEMO_SFLIGHT
{
  key CarrierID,
  key ConnectionID,
  key FlightDate,
      PlaneType,
      MaxSeatsEconomy,
      MaxSeatsBusinessClass,
      MaxSeatsFirstClass,
      Currency,
      //sflight.price as Price,
      //sflight.paymentsum as TotalPayments,
      OccupiedEconomy,
      OccupiedBusinessClass,
      OccupiedFirstClass,
      Sflight_ID,
      //case atomicOffset.AggregateId
      //    when '' then ''
      //    else 'X'
      //end as hasAtomicOffset,
      _CarbonAggregateCount,
      case
          when _CarbonAggregateCount.counter > 0 then 'X'
          else ''
      end                           as hasCarbonAggregate,
      _CarbonAggregate.CarbonAmount as CarbonAmount,
      _CarbonAggregate.CarbonUom    as CarbonUom,
      //_CarbonAggregateCount.counter as CarbonAggregateCount,

      case
          when _AOAggregate.counter > 0 then 'X'
          else ''
      end                           as hasAtomicOffset,

      case
          when _PoAOAggregate.counter > 0 then 'X'
          else ''
      end                           as hasPoAO,

      case
          when _CarbonAggregateCount.counter > 0 then '3'
          else '1'
      end                           as carbAggCrit,

      case
          when _AOAggregate.counter > 0 then '3'
          else '1'
      end                           as aoCrit,

      case
      
      when  _PoAOAggregate.counter > 0 then '3'
      else '1'
      end                           as poaoCrit,
      
      
      _CarbonRetirement.BeneficiaryAddressId as BeneficiaryAddressId,
      _CarbonRetirement.RetirementIndex as RetirementIndex,
      _CarbonRetirement.CertificateHref as RetirementPageURL,
      //concat('https://www.klimadao.finance/retirements/', concat(_CarbonRetirement.BeneficiaryAddressId, concat('/', _CarbonRetirement.RetirementIndex ))) as RetirementPageURL,
      //    case
      //  when _PoAOAggregate.counter > 0 then
      //      concat('https://shuttle.provide.services/workgroups/c6b1f23f-2021-4ab1-9158-ea07f6077c46/', 'workflows/858bdb7e-6ffc-4942-b998-72ccfcdc9d9d/designer')
      //      else ''
      //      end as ShuttleURL,
            
      _CarbonAggregate
      //_AtomicOffset,
      //_CarbonRetirement
}
