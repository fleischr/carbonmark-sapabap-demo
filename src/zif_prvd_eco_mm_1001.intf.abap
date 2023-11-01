INTERFACE zif_prvd_eco_mm_1001
  PUBLIC .

  TYPES: BEGIN OF ty_carbon_emission_mm1001,
           material             TYPE matnr,
           plant                TYPE werks_d,
           valid_from           TYPE datum,
           valid_to             TYPE datum,
           preferred_pool_token TYPE char10,
           carbon_amount        TYPE zprvd_eco_carbontonne,
           carbon_uom           TYPE meins,
         END OF ty_carbon_emission_mm1001.

  TYPES: ty_carbon_emission_mm1001_list TYPE TABLE OF ty_carbon_emission_mm1001 WITH KEY material plant .

  METHODS: create IMPORTING is_carbon_emission TYPE ty_carbon_emission_mm1001.
  METHODS: update IMPORTING is_carbon_emission TYPE ty_carbon_emission_mm1001.
  METHODS: read IMPORTING iv_material                TYPE matnr
                          iv_plant                   TYPE werks_d
                RETURNING VALUE(rs_carbon_emissions) TYPE ty_carbon_emission_mm1001.
  METHODS: query IMPORTING iv_material                TYPE matnr OPTIONAL
                           iv_plant                   TYPE werks_d OPTIONAL
                           iv_valid_from              TYPE datum OPTIONAL
                           iv_valid_to                TYPE datum OPTIONAL
                           iv_preferred_pool_token    TYPE char10 OPTIONAL
                           iv_carbon_amount           TYPE zprvd_eco_carbontonne OPTIONAL
                           iv_carbon_uom              TYPE meins OPTIONAL
                 RETURNING VALUE(rt_carbon_emissions) TYPE ty_carbon_emission_mm1001_list.
  METHODS: delete IMPORTING iv_material             TYPE matnr OPTIONAL
                            iv_plant                TYPE werks_d OPTIONAL
                            iv_valid_from           TYPE datum OPTIONAL
                            iv_valid_to             TYPE datum OPTIONAL
                            iv_preferred_pool_token TYPE char10 OPTIONAL
                            iv_carbon_amount        TYPE zprvd_eco_carbontonne OPTIONAL
                            iv_carbon_uom           TYPE meins OPTIONAL.

  METHODS: map_to_zprvdeco1001 IMPORTING is_carbon_emission_mm1001 TYPE ty_carbon_emission_mm1001
                               RETURNING VALUE(rs_zprvdeco1001)    TYPE zprvdeco1001.

  METHODS: map_from_zprvdeco1001 IMPORTING is_zprvdeco1001                  TYPE zprvdeco1001
                                 RETURNING VALUE(rs_carbon_emission_mm1001) TYPE ty_carbon_emission_mm1001.

ENDINTERFACE.
