@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Proof of Atomic Offset Axiom logs'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_PRVD_ECO_POAO_4240 as select from zbpiobj
    association[0..1] to ZI_PRVD_ECO_AO_4010 as _AtomicOffset on zbpiobj.object_id = _AtomicOffset.AtomicOffsetId
{
    key zbpiobj.object_id as ObjectId,
    key zbpiobj.baseline_id as BaselineId,
    zbpiobj.subject_account_id as SubjectAccountId,
    zbpiobj.workgroup_id as WorkgroupId,
    zbpiobj.schematype as Schematype,
    zbpiobj.schema_id as SchemaId,
    zbpiobj.status as Status,
    zbpiobj.proof as Proof,
    zbpiobj.created_by as CreatedBy,
    zbpiobj.created_at as CreatedAt,
    zbpiobj.changed_by as ChangedBy,
    zbpiobj.changed_at as ChangedAt,
    _AtomicOffset.AtomicOffsetId as AtomicOffsetId,
    _AtomicOffset.AggregateId as AggregateId,
    _AtomicOffset.RetirementId as RetirementId,
    
    _AtomicOffset
}
