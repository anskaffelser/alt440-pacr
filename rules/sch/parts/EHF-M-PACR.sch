<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns="http://purl.oclc.org/dsdl/schematron">

    <rule context="cac:ProviderParty">
        <assert id="EHF-PACR-R002"
                test="(cac:PartyName/cbc:Name) or (cac:PartyIdentification/cbc:ID)"
                flag="fatal">A catalogue provider SHALL contain the full name or an identifier</assert>
    </rule>

    <rule context="cac:ReceiverParty">
        <assert id="EHF-PACR-R003"
                test="(cac:PartyName/cbc:Name) or (cac:PartyIdentification/cbc:ID)"
                flag="fatal">A catalogue receiver SHALL contain the full name or an identifier</assert>
    </rule>

    <rule context="cac:RequiredItemLocationQuantity/cac:Price">
        <assert id="EHF-PACR-R006"
                test="number(cbc:PriceAmount) &gt;=0"
                flag="fatal">Prices of items SHALL not be negative</assert>
    </rule>
        
	
    <rule context="cac:CatalogueRequestLine">
        
        <let name="CatalogueReqLineValidityStart" value="if(exists(cac:LineValidityPeriod/cbc:StartDate)) then number(translate(cac:LineValidityPeriod/cbc:StartDate,'-','')) else 0"/>
        <let name="CatalogueReqLineValidityEnd" value="if(exists(cac:LineValidityPeriod/cbc:EndDate)) then number(translate(cac:LineValidityPeriod/cbc:EndDate,'-','')) else 99999999"/>
          
        <assert id="EHF-PACR-R013"
            test="($CatalogueReqLineValidityStart &lt;= $CatalogueReqLineValidityEnd)"
            flag="fatal">A line validity period end date SHALL be later or equal to the line validity period start date
        </assert>
       
    </rule>

</pattern>