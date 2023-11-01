@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Provide ECO - Carbon Retirement aggr'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_PRVD_ECO_CR_3401 as select distinct from ZI_PRVD_ECO_CR_3030
{
    key RetirementId,
    key NetworkId,
    key TxHash,
    key SourceToken,
    key PoolToken,
    key BeneficiaryAddressId,
    key BeneficiaryStringId,
    key RetirementMessageId,   
    key AtomicOffsetID,
    key CarbonAggregateID,
    @Aggregation.default: #SUM
    @DefaultAggregation: #COUNT
    CarbonAmount,
    CarbonUom,
    @Aggregation.default: #SUM
    @DefaultAggregation: #COUNT
    cast(1 as abap.int4) as counter
}
