@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Provide ECO - Carbon Aggregate Summary'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_PRVD_ECO_CA_2401 as select distinct from ZI_PRVD_ECO_CA_2010
{
    key AggregateId,
    key ObjectID,
    key ObjectType,
    @Aggregation.default: #SUM
    @DefaultAggregation: #COUNT
    CarbonAmount,
    CarbonUom,
    @Aggregation.default: #SUM
    @DefaultAggregation: #COUNT
    cast(1 as abap.int4) as counter
}
