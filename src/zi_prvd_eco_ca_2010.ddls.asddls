@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Provide ECO - Carbon Aggregates Interface view'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_PRVD_ECO_CA_2010 as select from zprvdeco2010
{
    key zprvdeco2010.aggregate_id as AggregateId,
    zprvdeco2010.objnr as ObjectID,
    zprvdeco2010.objid as ObjectType,
    zprvdeco2010.carbon_amount as CarbonAmount,
    zprvdeco2010.carbon_uom as CarbonUom
}
