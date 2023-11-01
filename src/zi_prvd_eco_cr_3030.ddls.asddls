@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Provide ECO - Carbon RetirementsS'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_PRVD_ECO_CR_3030 as select from zprvdeco3030 left outer join ZI_PRVD_ECO_AO_4010 as AtomicOffset on zprvdeco3030.retirement_id = AtomicOffset.RetirementId
{
    key zprvdeco3030.retirement_id as RetirementId,
    key zprvdeco3030.network_id as NetworkId,
    zprvdeco3030.tx_hash as TxHash,
    zprvdeco3030.source_token as SourceToken,
    zprvdeco3030.pool_token as PoolToken,
    zprvdeco3030.carbon_amount as CarbonAmount,
    zprvdeco3030.carbon_uom as CarbonUom,
    zprvdeco3030.beneficiary_address_id as BeneficiaryAddressId,
    zprvdeco3030.beneficiary_string_id as BeneficiaryStringId,
    zprvdeco3030.retirement_message_id as RetirementMessageId,
    cast(zprvdeco3030.retirement_index as abap.char( 100 )) as RetirementIndex,
    zprvdeco3030.certificate_href as CertificateHref, 
    AtomicOffset.AtomicOffsetId as AtomicOffsetID,
    AtomicOffset.AggregateId as CarbonAggregateID
}
