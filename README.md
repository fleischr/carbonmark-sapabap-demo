# Carbonmark SAP S/4 HANA ABAP Integration Demo

This application demonstrates integration of the Carbonmark Offset API to carbon emissions data calculated from the SFLIGHT table in SAP S/4 HANA, with ABAP.

## How this app works - high level
- Calculate carbon emissions of the SFLIGHT data entries
- Configure a preferred carbon project based on pool and project identifiers from Carbonmark - the largest global marketplace of digital carbon offsets
- Use the Provide digital wallet-as-a-service offering to purchase and retire digital carbon offsets from Carbonmark
- Certificates of the carbon retirement are available on the Carbonmark website as well as the Polygon Matic blockchain and related environmental registry
- SAP user is invoiced and billed in arrears for their total purchase of carbon retirements
- Memorialize the linkage of the carbon emissions data record to the carbon offset with proof of atomic offset

## Highlights
- Instantly and effortlessly source carbon offset retirements on demand for any SAP business activity with carbon emissions
- Acquire certificates of your carbon retirement in real time with details on your selected vintage, UN SDGs, region, methodology, and other environmental registry details
- Your first tonne is free! You've been given complimentary access to retire a small batch of carbon courtesy of Provide
- First ever documented integration of the Circle USDC stablecoin, Polygon Matic blockchain network to SAP S/4 HANA
- Benefit from blockchain's advantages in carbon offset retirements with zero risk exposure to holding digital assets
- Maintain privacy and high fidelity of your public data disclosures with Provide's tools in RSA encryption and zero knowledge cryptography

## Pre requisites (do these first before running code!)
- Clone [provide-abap](https://github.com/provideplatform/provide-abap) to your SAP system
- Activate the provide-abap SICF node
- In transaction code STRUST, configure the SSL certificates needed for Provide stack (see certificates directory of the provide-abap repo)
- Create an account at https://shuttle.provide.services. Create organization at minimum (workgroup creation is recommended but optional).
- You can also [generate credentials manually with Postman](https://github.com/provideplatform/eco-api-resources/blob/main/postman/Carbonmark%20API%20-%20Provide%20Payments%20User%20signup.postman_collection.json). 

## Configuration

### Postman configuration
- Import the provided Postman collection. 
- Maintain the shuttle_email and shuttle_password collection variables accordingly
- Maintain SAP user id and password in the Postman collection
- Enter the web dispatcher base url (ex: fiorilaunchpad.mycompany.com) to the sapbaseurl collection variable
- Run the HTTP requests in the following order:
1. Get access token with login
2. List organizations
3. Generate long-dated refresh token
4. Get access token from refresh token
5. Create account (Do both Polygon Mumbai and Celo Alfajores)
6. List accounts (take note of the address field for later!)
7. SAP / provide-abap fetch token
8. SAP / provide-abap tenants create

Steps 7 an 8 populate your Provide credentials to the SAP system. 

## Tech how-to

Activate the oData service

Open the Fiori elements preview

You can also preview, build, and deploy the corresponding SAPUI5 app in [this repo](https://github.com/fleischr/carbonmark-sapui5-demo)

## Recommendation 
Review the [Provide ECO API Resource Hub](https://github.com/provideplatform/eco-api-resources) for more important details on the Carbonmark API and other integrations

## Next steps
Ready to integrate to your dev, QA, or production SAP environment? Contact Ryan (ryan@provide.services) and Liam (liam@carbonmark.com) for more details!

Discover more and see it action!

Youtube:

[![Carbonmark SAP integrations with Provide Payments](https://img.youtube.com/vi/O8dsJc8QVhM/0.jpg)](https://www.youtube.com/embed/O8dsJc8QVhM?si=adJAchxp4hVvaTJR&amp;start=692)
