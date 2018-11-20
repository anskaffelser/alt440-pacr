<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns="http://purl.oclc.org/dsdl/schematron">
        
        <let name="CatalogueValidityStart" value="if(exists(/ubl:Catalogue/cac:ValidityPeriod/cbc:StartDate)) then number(translate(/ubl:Catalogue/cac:ValidityPeriod/cbc:StartDate,'-','')) else 0"/>
        <let name="CatalogueValidityEnd" value="if(exists(/ubl:Catalogue/cac:ValidityPeriod/cbc:EndDate)) then number(translate(/ubl:Catalogue/cac:ValidityPeriod/cbc:EndDate,'-','')) else 99999999"/>

    <rule context="/ubl:Catalogue/cac:ValidityPeriod">
        <assert id="EHF-PAC-R001"
                test="$CatalogueValidityEnd &gt;= $CatalogueValidityStart"
                flag="fatal">A validity period end date SHALL be later or equal to a validity period start date</assert>
    </rule>

    <rule context="cac:ProviderParty">
        <assert id="EHF-PAC-R002"
                test="(cac:PartyName/cbc:Name) or (cac:PartyIdentification/cbc:ID)"
                flag="fatal">A catalogue provider SHALL contain the full name or an identifier</assert>
    </rule>

    <rule context="cac:ReceiverParty">
        <assert id="EHF-PAC-R003"
                test="(cac:PartyName/cbc:Name) or (cac:PartyIdentification/cbc:ID)"
                flag="fatal">A catalogue receiver SHALL contain the full name or an identifier</assert>
    </rule>

    <rule context="cac:SellerSupplierParty">
        <assert id="EHF-PAC-R004"
                test="(cac:Party/cac:PartyName/cbc:Name) or (cac:Party/cac:PartyIdentification/cbc:ID)"
                flag="fatal">A catalogue supplier SHALL contain the full name or an identifier</assert>
    </rule>

    <rule context="cac:ContractorCustomerParty">
        <assert id="EHF-PAC-R005"
                test="(cac:Party/cac:PartyName/cbc:Name) or (cac:Party/cac:PartyIdentification/cbc:ID)"
                flag="fatal">A catalogue customer SHALL contain the full name or an identifier</assert>
    </rule>

    <rule context="cac:RequiredItemLocationQuantity/cac:Price">
        <assert id="EHF-PAC-R006"
                test="number(cbc:PriceAmount) &gt;=0"
                flag="fatal">Prices of items SHALL not be negative</assert>
    </rule>
        
	
    <rule context="cac:CatalogueLine">
        
        <let name="CatalogueLineValidityStart" value="if(exists(cac:LineValidityPeriod/cbc:StartDate)) then number(translate(cac:LineValidityPeriod/cbc:StartDate,'-','')) else $CatalogueValidityStart"/>
        <let name="CatalogueLineValidityEnd" value="if(exists(cac:LineValidityPeriod/cbc:EndDate)) then number(translate(cac:LineValidityPeriod/cbc:EndDate,'-','')) else $CatalogueValidityEnd"/>
        <let name="CataloguePriceValidityStart" value="if(exists(cac:RequiredItemLocationQuantity/cac:Price/cac:ValidityPeriod/cbc:StartDate)) then number(translate(cac:RequiredItemLocationQuantity/cac:Price/cac:ValidityPeriod/cbc:StartDate,'-','')) else $CatalogueLineValidityStart"/>
        <let name="CataloguePriceValidityEnd" value="if(exists(cac:RequiredItemLocationQuantity/cac:Price/cac:ValidityPeriod/cbc:EndDate)) then number(translate(cac:RequiredItemLocationQuantity/cac:Price/cac:ValidityPeriod/cbc:EndDate,'-','')) else $CatalogueLineValidityEnd"/>
        
        
        <assert id="EHF-PAC-R008"
                test="not(cbc:MaximumOrderQuantity) or number(cbc:MaximumOrderQuantity) &gt;= 0"
                flag="fatal">Maximum quantity SHALL be greater than zero</assert>

        <assert id="EHF-PAC-R009"
                test="not(cbc:MinimumOrderQuantity) or number(cbc:MinimumOrderQuantity) &gt;= 0"
                flag="fatal">Minimum quantity SHALL be greater than zero</assert>

        <assert id="EHF-PAC-R010"
                test="not(cbc:MaximumOrderQuantity) or not(cbc:MinimumOrderQuantity) or number(cbc:MaximumOrderQuantity) &gt;= number(cbc:MinimumOrderQuantity)"
                flag="fatal">Maximum quantity SHALL be greater or equal to the Minimum quantity</assert>
               
        <assert id="EHF-PAC-R007"
            test="($CatalogueLineValidityStart &gt;= $CatalogueValidityStart) and ($CatalogueLineValidityStart &lt;= $CatalogueValidityEnd) 
            and ($CatalogueLineValidityEnd &lt;= $CatalogueValidityEnd) and ($CatalogueLineValidityEnd &gt;= $CatalogueValidityStart)"        
            flag="fatal">Catalogue line validity period SHALL be within the range of the whole catalogue validity period</assert>
        
        <assert id="EHF-PAC-R013"
            test="($CatalogueLineValidityStart &lt;= $CatalogueLineValidityEnd)"
            flag="fatal">A line validity period end date SHALL be later or equal to the line validity period start date
        </assert>
        
        <assert id="EHF-PAC-R011"
            test="($CataloguePriceValidityStart &gt;= $CatalogueLineValidityStart) and ($CataloguePriceValidityStart &lt;= $CatalogueLineValidityEnd) 
            and ($CataloguePriceValidityEnd &lt;= $CatalogueLineValidityEnd) and ($CataloguePriceValidityEnd &gt;= $CatalogueLineValidityStart)"        
            flag="fatal">Price validity start date SHALL be within the range of the catalogue line or catalogue validity period</assert>
        <assert id="EHF-PAC-R016"
            test="($CataloguePriceValidityStart &lt;= $CataloguePriceValidityEnd)"
            flag="fatal">A price validity period end date SHALL be later or equal to the price validity period start date
        </assert>
    </rule>

    <rule context="cac:ClassifiedTaxCategory">
        <assert id="EHF-PAC-R014"
            test="cbc:Percent or (normalize-space(cbc:ID)='O')"
            flag="fatal">Each Tax Category SHALL have a VAT category rate, except if the catalogue line is not subject to VAT.</assert>
        <assert id="EHF-PAC-R015"
            test="not(normalize-space(cbc:ID)='S') or (cbc:Percent) &gt; 0"
            flag="fatal">When VAT category code is "Standard rated" (S) the VAT rate SHALL be greater than zero.</assert>
    </rule>

    <rule context="cac:Item">
        <assert id="EHF-PAC-R012"
                test="(cac:StandardItemIdentification/cbc:ID) or (cac:SellersItemIdentification/cbc:ID)"
                flag="fatal">Each item in a Catalogue line SHALL be identifiable by either “item sellers identifier” or “item standard identifier”</assert>
    </rule>



</pattern>