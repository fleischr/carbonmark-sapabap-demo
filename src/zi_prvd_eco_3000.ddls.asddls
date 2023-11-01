@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Provide ECO - Source and Pool Tokens - Interface view'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_PRVD_ECO_3000 as select from zprvdeco3000 {
    key zprvdeco3000.network_id as NetworkID,
    key zprvdeco3000.token_address as TokenAddress,
    zprvdeco3000.token_abbr as Token,
    zprvdeco3000.token_desc as TokenDescription,
    zprvdeco3000.token_type as TokenType
}
