CLASS zcl_provide_eco_demo_data DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS: generate_data IMPORTING iv_scenario TYPE char10.
  PROTECTED SECTION.
    METHODS: generate_sflight_data.
    METHODS: generate_epm_data.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_provide_eco_demo_data IMPLEMENTATION.

  METHOD generate_data.
    CASE iv_scenario.
      WHEN 'SFLIGHT'.
        generate_sflight_data( ).
      WHEN 'EPM'.
        generate_epm_data( ).
      WHEN OTHERS.
    ENDCASE.
  ENDMETHOD.

  METHOD generate_sflight_data.
  ENDMETHOD.

  METHOD generate_epm_data.
  ENDMETHOD.

ENDCLASS.
