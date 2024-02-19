@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Provide ECO - PoAO Aggregation'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_PRVD_ECO_POAO_4402 as select distinct from ZI_PRVD_ECO_POAO_4240 
{
    key ObjectId,
    key BaselineId,
    key SubjectAccountId,
    key WorkgroupId,
    key Schematype,
    key SchemaId,
    //zbpiobj.status as Status,
    //zbpiobj.proof as Proof,
    key CreatedBy,
    //zbpiobj.created_at as CreatedAt,
    key ChangedBy,
    //zbpiobj.changed_at as ChangedAt,
    key AtomicOffsetId,
    key AggregateId,
    key RetirementId,
    @Aggregation.default: #SUM
    cast(1 as abap.int4) as counter
}
