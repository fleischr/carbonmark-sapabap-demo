@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Atomic Offset Interface CDS view'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_PRVD_ECO_AO_4010 as select from zprvdeco4010
    association[0..1] to ZI_PRVD_ECO_CA_2010 as _CarbonAggregate on $projection.AggregateId = _CarbonAggregate.AggregateId
    association[0..1] to ZI_PRVD_ECO_CR_3030 as _CarbonRetirement on $projection.RetirementId = _CarbonRetirement.RetirementId
{
    key zprvdeco4010.atomic_offset_id as AtomicOffsetId,
    zprvdeco4010.aggregate_id as AggregateId,
    zprvdeco4010.objnr as ObjectID,
    zprvdeco4010.objid as ObjectType,
    zprvdeco4010.retirement_id as RetirementId,
    zprvdeco4010.atomic_offset_amount as AtomicOffsetAmount,
    zprvdeco4010.atomic_offset_uom as AtomicOffsetUom,
    
    _CarbonAggregate,
    _CarbonRetirement
}
