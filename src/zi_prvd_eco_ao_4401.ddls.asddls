@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Provide ECO - Atomic Offset Report Aggregations'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_PRVD_ECO_AO_4401 as select distinct from ZI_PRVD_ECO_AO_4010
{
    key AtomicOffsetId,
    key AggregateId,
    key ObjectID,
    key ObjectType,
    key RetirementId,
    key AtomicOffsetUom,
    @Aggregation.default: #SUM
    @DefaultAggregation: #COUNT
    AtomicOffsetAmount,
    
    @Aggregation.default: #SUM
    @DefaultAggregation: #COUNT
    cast(1 as abap.int4) as counter
}
