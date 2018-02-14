<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:mads="http://www.loc.gov/mads/v2" 
	xmlns:local="http://www.loc.org/namespace"
	xmlns:xlink="http://www.w3.org/1999/xlink"
	xmlns:marc="http://www.loc.gov/MARC21/slim"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="marc">

	<xsl:include href="http://www.loc.gov/marcxml/xslt/MARC21slimUtils.xsl"/>
	<xsl:output method="xml" indent="yes" encoding="UTF-8"/>
	<xsl:strip-space elements="*"/>

	<!--
		2.14    Fixed bug in mads:geographic attributes syntax                                      ws   05/04/2016
		2.13    added $2 authority for <classification>                                             ws   09/24/2012
		2.12    added delimiters between <classification> subfields                                 ws   09/24/2012
		2.11 	Changed from xlst 1.0 to xslt 2.0													ws   06/14/2012
					Replaced templates sufieldSelect SpecialSubfieldSelect and chopPunctuation with local functions.
					local:stripPunctation function to tests for initials and leaves punctuation if needed.
					Improved handling of mads:collection records
		2.10	fixed type=other and type=otherType for mads:related								tmee 09/16/2011
		2.09	fixed professionTerm and genreTerm empty tag error									tmee 09/16/2011
		2.08	fixed marc:subfield @code='i' matching error										tmee 09/16/2011
		2.07	fixed 555 duplication error															tmee 08/10/2011	
		2.06	fixed topic subfield error															tmee 08/10/2011	
		2.05	fixed title subfield error															tmee 06/20/2011	
		2.04	fixed geographicSubdivision mapping for authority element							tmee 06/16/2011
		2.03	added classification for 053, 055, 060, 065, 070, 080, 082, 083, 086, 087			tmee 06/03/2011		
		2.02	added descriptionStandard for 008/10												tmee 04/27/2011
		2.01	added extensions for 046, 336, 370, 374, 375, 376									tmee 04/08/2011
		2.00	redefined imported MODS elements in version 1.0 to MADS elements in version 2.0		tmee 02/08/2011
		1.08	added 372 subfields $a $s $t for <fieldOfActivity>									tmee 06/24/2010
		1.07	removed role/roleTerm 100, 110, 111, 400, 410, 411, 500, 510, 511, 700, 710, 711	tmee 06/24/2010
		1.06	added strip-space																	tmee 06/24/2010
		1.05	added subfield $a for 130, 430, 530													tmee 06/21/2010
		1.04	fixed 550 z omission																ntra 08/11/2008
		1.03	removed duplication of 550 $a text													tmee 11/01/2006
		1.02	fixed namespace references between mads and mods									ntra 10/06/2006
		1.01	revised																				rgue/jrad 11/29/05
		1.00	adapted from MARC21Slim2MODS3.xsl												ntra 07/06/05
	-->
	
	<!-- Local functions -->
	<!--  
		Strips punctuation from the last character of a field.
		To extend add any additional punctuation to the punctuation variable
		$str: string to be analyzed
	-->
	<xsl:function name="local:stripPunctuation">
		<xsl:param name="str"/>
		<xsl:variable name="punctuation">.:,;/ </xsl:variable>
		<!-- isolates end of string -->
		<xsl:variable name="strEnd">
			<xsl:value-of select="substring($str,(string-length($str)))"/>
		</xsl:variable>
		<!-- isolates last three characters in string tests for initials -->
		<xsl:variable name="initialTest">
			<xsl:variable name="lastChars" select="substring($str,(string-length($str)) - 2)"/>
			<xsl:choose>
				<xsl:when test="matches($lastChars,'^([.][A-Z][.])')">true</xsl:when>
				<xsl:when test="matches($lastChars,'^([ ][A-Z][.])')">true</xsl:when>
				<xsl:when test="matches($lastChars,'^([.][.][.])')">true</xsl:when>
				<xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="contains($punctuation,$strEnd)">
				<xsl:choose>
					<!-- if ends with initials or ellipse then leave, otherwise remove ending punctuation -->
					<xsl:when test="$initialTest = 'true'"><xsl:value-of select="$str"/></xsl:when>
					<!-- if ends with multiple punctiation -->
					<xsl:when test="matches(substring($str,(string-length($str))-3),'([.:,;/][ ][.:,;/])')">
						<xsl:value-of select="substring($str,1,string-length($str)-3)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring($str,1,string-length($str)-1)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$str"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
	
	<!-- 
		Strips punctuation from the last character of a field, this version accepts two parameters:
		$str: string to be striped
		$pcodes: optional punctuation to override the defualt, if empty uses defualts
	-->
	<xsl:function name="local:stripPunctuation">
		<xsl:param name="str"/>
		<xsl:param name="pcodes"/>
		<xsl:variable name="punctuation">
			<xsl:choose>
				<xsl:when test="$pcodes = ''">.:,;/ </xsl:when>
				<xsl:otherwise><xsl:value-of select="$pcodes"></xsl:value-of></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="strEnd">
			<xsl:value-of select="substring($str,(string-length($str)))"/>
		</xsl:variable>
		<xsl:variable name="initialTest">
			<xsl:variable name="lastChars" select="substring($str,(string-length($str)) - 1)"/>
			<xsl:choose>
				<xsl:when test="matches($lastChars,'^([.][A-Z][.])')">true</xsl:when>
				<xsl:when test="matches($lastChars,'^([ ][A-Z][.])')">true</xsl:when>
				<xsl:when test="matches($lastChars,'^([.][.][.])')">true</xsl:when>
				<xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="contains($punctuation,$strEnd)">
				<xsl:choose>
					<xsl:when test="$initialTest = 'true'"><xsl:value-of select="$str"/></xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring($str,1,string-length($str)-1)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$str"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
	
	<!-- 
		Concats specified subfields in order they appear in marc record
		Two prameters
		$datafield: marc:datafield node to use for processing
		$codes: list of subfield codes, no spaces
	-->
	<xsl:function name="local:subfieldSelect">
		<xsl:param name="datafield" as="node()"/>
		<xsl:param name="codes"/>
		<!-- Breaks out codes for a for each loop -->		
		<xsl:variable name="codeString">
			<xsl:for-each select="$codes">
				<xsl:apply-templates/>
			</xsl:for-each>
		</xsl:variable>
		<!-- Selects and prints out datafield -->
		<xsl:variable name="str">
			<xsl:for-each select="$datafield/child::*[contains($codes,@code)]">
				<xsl:value-of select="concat(.,' ')"/>
			</xsl:for-each>
		</xsl:variable>
		<xsl:value-of select="substring($str,1,string-length($str)-1)"/>
	</xsl:function>
	
	<!-- 
		Concats specified subfields in order they appear in marc record with specified delimiter 
		Three parameters
		$datafield: marc:datafield node to use for processing
		$codes: list of subfield codes, no spaces
		$delimiter: delimiter to use when concating subfields, if empty a space is used
	-->
	<xsl:function name="local:subfieldSelect">
		<xsl:param name="datafield" as="node()"/>
		<xsl:param name="codes"/>
		<xsl:param name="delimiter"/>
		<xsl:variable name="delimStr">
			<xsl:choose>
				<xsl:when test="$delimiter = ''"><xsl:value-of select="' '"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$delimiter"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!-- Breaks out codes for a for each loop -->
		<xsl:variable name="codeString">
			<xsl:for-each select="$codes">
				<xsl:apply-templates/>
			</xsl:for-each>
		</xsl:variable>
		<!-- Selects and prints out datafield -->
		<xsl:variable name="str">
			<xsl:for-each select="$datafield/child::*[contains($codes,@code)]">
				<xsl:value-of select="concat(.,$delimStr)"/>
			</xsl:for-each>
		</xsl:variable>
		<xsl:value-of select="substring($str,1,string-length($str)-1)"/>
	</xsl:function>
	
	<!-- 
		Concats specified subfields based on siblings
		$anyCode: the subfield you want to select on
		$axis: the that beforeCodes and afterCodes are computed
		$beforeCodes: subfields that occure before the axis
		$afterCodes: subfields that occure after the axis
	-->	
	<xsl:function name="local:specialSubfieldSelect">
		<xsl:param name="datafield" as="node()"/>
		<xsl:param name="anyCodes"/>
		<xsl:param name="axis"/>
		<xsl:param name="beforeCodes"/>
		<xsl:param name="afterCodes"/>
		<xsl:variable name="codeString">
			<xsl:for-each select="$anyCodes">
				<xsl:apply-templates/>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="subfieldStr">
			<xsl:for-each select="$datafield/child::*[contains($anyCodes, @code) 
				or (contains($beforeCodes,@code) and following-sibling::*[@code=$axis])  
				or (contains($afterCodes,@code) and preceding-sibling::*[@code=$axis])]">
				<xsl:apply-templates/><xsl:text> </xsl:text>
			</xsl:for-each>
		</xsl:variable>
		<xsl:value-of select="substring($subfieldStr,1,string-length($subfieldStr)-1)"/>
	</xsl:function>	
	
	<!-- authority attribute defaults to 'naf' if not set using this authority parameter, for <authority> descriptors: name, titleInfo, geographic -->
	<xsl:param name="authority"/>
	<xsl:variable name="auth">
		<xsl:choose>
			<xsl:when test="$authority">
				<xsl:value-of select="$authority"/>
			</xsl:when>
			<xsl:otherwise>naf</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<!-- Establish root mads:collection or mads:mads  -->
	<xsl:template match="/">
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="marc:collection">
		<mads:madsCollection xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
			xsi:schemaLocation="http://www.loc.gov/mads/v2 http://www.loc.gov/standards/mads/v2/mads-2-0.xsd">
			<xsl:apply-templates select="marc:record"/>
		</mads:madsCollection>
	</xsl:template>
	
	<xsl:template match="marc:record">
		<!-- Control field variabels -->
		<xsl:variable name="controlField008" select="marc:controlfield[@tag='008']"/>
		<xsl:variable name="controlField008-06" select="substring(marc:controlfield[@tag=008],7,1)"/>
		
		<mads:mads version="2.0">
			<!-- Adds appropriate namespaces and schema declaration if root is marc:record -->
			<xsl:if test="/marc:record">
				<xsl:namespace name="xsi">http://www.w3.org/2001/XMLSchema-instance</xsl:namespace>
				<xsl:attribute name="xsi:schemaLocation">http://www.loc.gov/mads/v2 http://www.loc.gov/standards/mads/v2/mads-2-0.xsd</xsl:attribute>
			</xsl:if>
			
			<!-- Build authority element -->
			<mads:authority>
				<!-- 2.04 : add geogrpahicSubdivision attribute based on controlfield 008 values -->
				<xsl:choose>
					<xsl:when test="$controlField008-06='d'">
						<xsl:attribute name="geographicSubdivision">
							<xsl:text>direct</xsl:text>
						</xsl:attribute>
					</xsl:when>				
					<xsl:when test="$controlField008-06='i'">
						<xsl:attribute name="geographicSubdivision">
							<xsl:text>indirect</xsl:text>
						</xsl:attribute>
					</xsl:when>
					<xsl:when test="$controlField008-06='n'">
						<xsl:attribute name="geographicSubdivision">
							<xsl:text>not applicable</xsl:text>
						</xsl:attribute>
					</xsl:when>
				</xsl:choose>
				<!-- Builds authority elements from marc datafields -->
				<xsl:apply-templates select="marc:datafield[100 &lt;= @tag and @tag &lt; 200]"/>		
			</mads:authority>

			<!-- related -->
			<xsl:apply-templates select="marc:datafield[500 &lt;= @tag and @tag &lt;= 585]|marc:datafield[700 &lt;= @tag and @tag &lt;= 785]"/>
	
			<!-- variant -->
			<xsl:apply-templates select="marc:datafield[400 &lt;= @tag and @tag &lt;= 485]"/>
	
			<!-- notes -->
			<xsl:apply-templates select="marc:datafield[667 &lt;= @tag and @tag &lt;= 688]"/>
	
			<!-- url -->
			<xsl:apply-templates select="marc:datafield[@tag=856]"/>
			<xsl:apply-templates select="marc:datafield[@tag=010]"/>
			<xsl:apply-templates select="marc:datafield[@tag=024]"/>
			<xsl:apply-templates select="marc:datafield[@tag=372]"/>
			
			<!-- classification -->
			<xsl:apply-templates select="marc:datafield[@tag=053]"/>
			<xsl:apply-templates select="marc:datafield[@tag=055]"/>
			<xsl:apply-templates select="marc:datafield[@tag=060]"/>
			<xsl:apply-templates select="marc:datafield[@tag=065]"/>
			<xsl:apply-templates select="marc:datafield[@tag=070]"/>
			<xsl:apply-templates select="marc:datafield[@tag=080]"/>
			<xsl:apply-templates select="marc:datafield[@tag=082]"/>
			<xsl:apply-templates select="marc:datafield[@tag=083]"/>
			<xsl:apply-templates select="marc:datafield[@tag=086]"/>
			<xsl:apply-templates select="marc:datafield[@tag=087]"/>
	
			<!-- affiliation-->
			<xsl:apply-templates select="marc:datafield[@tag=373]"/>
			<xsl:apply-templates select="marc:datafield[@tag=371]"/>
	
			<!-- extension-->
			<xsl:apply-templates select="marc:datafield[@tag=336]"/>
			<xsl:apply-templates select="marc:datafield[@tag=374]"/>
			<xsl:apply-templates select="marc:datafield[@tag=375]"/>
			<xsl:apply-templates select="marc:datafield[@tag=376]"/>
	
			<mads:recordInfo>
				<mads:recordOrigin>Converted from MARCXML to MADS version 2.0 (Revision 2.13, 2012/09/24)</mads:recordOrigin>
				<!-- <xsl:apply-templates select="marc:datafield[@tag=024]"/> -->
	
				<xsl:apply-templates select="marc:datafield[@tag=040]/marc:subfield[@code='a']"/>
				<xsl:apply-templates select="marc:controlfield[@tag=005]"/>
				<xsl:apply-templates select="marc:controlfield[@tag=001]"/>
				<xsl:apply-templates select="marc:datafield[@tag=040]/marc:subfield[@code='b']"/>
				<xsl:apply-templates select="marc:datafield[@tag=040]/marc:subfield[@code='e']"/>
				<xsl:for-each select="marc:controlfield[@tag=008]">
					<xsl:if test="substring(.,11,1)='a'">
						<mads:descriptionStandard>
							<xsl:text>earlier rules</xsl:text>
						</mads:descriptionStandard>
					</xsl:if>
					<xsl:if test="substring(.,11,1)='b'">
						<mads:descriptionStandard>
							<xsl:text>aacr1</xsl:text>
						</mads:descriptionStandard>
					</xsl:if>
					<xsl:if test="substring(.,11,1)='c'">
						<mads:descriptionStandard>
							<xsl:text>aacr2</xsl:text>
						</mads:descriptionStandard>
					</xsl:if>
					<xsl:if test="substring(.,11,1)='d'">
						<mads:descriptionStandard>
							<xsl:text>aacr2 compatible</xsl:text>
						</mads:descriptionStandard>
					</xsl:if>
					<xsl:if test="substring(.,11,1)='z'">
						<mads:descriptionStandard>
							<xsl:text>other rules</xsl:text>
						</mads:descriptionStandard>
					</xsl:if>
				</xsl:for-each>
			</mads:recordInfo>
		</mads:mads>
	</xsl:template>

	<!-- start of secondary templates -->

	<!-- ======== xlink ======== -->

	<!-- <xsl:template name="uri"> 
    <xsl:for-each select="marc:subfield[@code='0']">
      <xsl:attribute name="xlink:href">
	<xsl:value-of select="."/>
      </xsl:attribute>
    </xsl:for-each>
     </xsl:template> 
   -->
	<xsl:template match="marc:subfield[@code='i']">
		<xsl:attribute name="otherType">
			<xsl:value-of select="."/>
		</xsl:attribute>
	</xsl:template>

	<!-- No role/roleTerm mapped in MADS 06/24/2010
	<xsl:template name="role">
		<xsl:for-each select="marc:subfield[@code='e']">
			<mads:role>
				<mads:roleTerm type="text">
					<xsl:value-of select="."/>
				</mads:roleTerm>
			</mads:role>
		</xsl:for-each>
	</xsl:template>
-->

	<xsl:template name="part">
		<xsl:variable name="partNumber">
			<xsl:value-of select="local:specialSubfieldSelect(.,'n','n','','fghkdlmor')"></xsl:value-of>
		</xsl:variable>
		<xsl:variable name="partName">
			<xsl:value-of select="local:specialSubfieldSelect(.,'p','p','','fghkdlmor')"></xsl:value-of>
		</xsl:variable>
		<xsl:if test="string-length(normalize-space($partNumber))">
			<mads:partNumber>
				<xsl:value-of select="local:stripPunctuation($partNumber)"/>
			</mads:partNumber>
		</xsl:if>
		<xsl:if test="string-length(normalize-space($partName))">
			<mads:partName>
				<xsl:value-of select="local:stripPunctuation($partName)"/>
			</mads:partName>
		</xsl:if>
	</xsl:template>

	<xsl:template name="nameABCDN">
		<xsl:for-each select="marc:subfield[@code='a']">
			<mads:namePart>
				<xsl:value-of select="local:stripPunctuation(.)"/>
			</mads:namePart>
		</xsl:for-each>
		<xsl:for-each select="marc:subfield[@code='b']">
			<mads:namePart>
				<xsl:value-of select="."/>
			</mads:namePart>
		</xsl:for-each>
		<xsl:if test="marc:subfield[@code='c'] or marc:subfield[@code='d'] or marc:subfield[@code='n']">
			<mads:namePart>
				<xsl:value-of select="local:subfieldSelect(.,'cdn')"/>
			</mads:namePart>
		</xsl:if>
	</xsl:template>

	<xsl:template name="nameABCDQ">
		<mads:namePart>
			<xsl:value-of select="local:stripPunctuation(local:subfieldSelect(.,'aq'))"/>
		</mads:namePart>
		<xsl:call-template name="termsOfAddress"/>
		<xsl:call-template name="nameDate"/>
	</xsl:template>

	<xsl:template name="nameACDENQ">
		<mads:namePart>
			<xsl:value-of select="local:subfieldSelect(.,'acdenq')"/>
		</mads:namePart>
	</xsl:template>

	<xsl:template name="nameDate">
		<xsl:for-each select="marc:subfield[@code='d']">
			<mads:namePart type="date">
				<xsl:value-of select="local:stripPunctuation(.)"/>
			</mads:namePart>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="termsOfAddress">
		<xsl:if test="marc:subfield[@code='b' or @code='c']">
			<mads:namePart type="termsOfAddress">
				<xsl:value-of select="local:stripPunctuation(local:subfieldSelect(.,'bc'))"/>
			</mads:namePart>
		</xsl:if>
	</xsl:template>

	<xsl:template name="displayLabel">
		<xsl:if test="marc:subfield[@code='z']">
			<xsl:attribute name="displayLabel">
				<xsl:value-of select="marc:subfield[@code='z']"/>
			</xsl:attribute>
		</xsl:if>
		<xsl:if test="marc:subfield[@code='3']">
			<xsl:attribute name="displayLabel">
				<xsl:value-of select="marc:subfield[@code='3']"/>
			</xsl:attribute>
		</xsl:if>
	</xsl:template>

	<xsl:template name="isInvalid">
		<xsl:if test="@code='z'">
			<xsl:attribute name="invalid">yes</xsl:attribute>
		</xsl:if>
	</xsl:template>

	<xsl:template name="sub2Attribute">
		<!-- 024 -->
		<xsl:if test="../marc:subfield[@code='2']">
			<xsl:attribute name="type">
				<xsl:value-of select="../marc:subfield[@code='2']"/>
			</xsl:attribute>
		</xsl:if>
	</xsl:template>

	<xsl:template match="marc:controlfield[@tag=001]">
		<mads:recordIdentifier>
			<xsl:if test="../marc:controlfield[@tag=003]">
				<xsl:attribute name="source">
					<xsl:value-of select="../marc:controlfield[@tag=003]"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:value-of select="."/>
		</mads:recordIdentifier>
	</xsl:template>

	<xsl:template match="marc:controlfield[@tag=005]">
		<mads:recordChangeDate encoding="iso8601">
			<xsl:value-of select="."/>
		</mads:recordChangeDate>
	</xsl:template>

	<xsl:template match="marc:controlfield[@tag=008]">
		<mads:recordCreationDate encoding="marc">
			<xsl:value-of select="substring(.,1,6)"/>
		</mads:recordCreationDate>
	</xsl:template>

	<xsl:template match="marc:datafield[@tag=010]">
		<xsl:for-each select="marc:subfield">
			<mads:identifier type="lccn">
				<xsl:call-template name="isInvalid"/>
				<xsl:value-of select="."/>
			</mads:identifier>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="marc:datafield[@tag=024]">
		<xsl:for-each select="marc:subfield[not(@code=2)]">
			<mads:identifier>
				<xsl:call-template name="isInvalid"/>
				<xsl:call-template name="sub2Attribute"/>
				<xsl:value-of select="."/>
			</mads:identifier>
		</xsl:for-each>
	</xsl:template>

	<!-- ========== 372 ========== -->
	<xsl:template match="marc:datafield[@tag=372]">
		<mads:fieldOfActivity>
			<xsl:value-of select="local:subfieldSelect(.,'a')"/>
			<xsl:text>-</xsl:text>
			<xsl:value-of select="local:subfieldSelect(.,'st')"/>
		</mads:fieldOfActivity>
	</xsl:template>


	<!-- ========== 040 ========== -->
	<xsl:template match="marc:datafield[@tag=040]/marc:subfield[@code='a']">
		<mads:recordContentSource authority="marcorg">
			<xsl:value-of select="."/>
		</mads:recordContentSource>
	</xsl:template>

	<xsl:template match="marc:datafield[@tag=040]/marc:subfield[@code='b']">
		<mads:languageOfCataloging>
			<mads:languageTerm authority="iso639-2b" type="code">
				<xsl:value-of select="."/>
			</mads:languageTerm>
		</mads:languageOfCataloging>
	</xsl:template>

	<xsl:template match="marc:datafield[@tag=040]/marc:subfield[@code='e']">
		<mads:descriptionStandard>
			<xsl:value-of select="."/>
		</mads:descriptionStandard>
	</xsl:template>
	
	<!-- ========== classification 2.03 ========== -->
	<!-- 2.12 added delimeters  ws-->
	<xsl:template match="marc:datafield[@tag=053]">
		<mads:classification>
			<xsl:value-of select="local:subfieldSelect(.,'abcdxyz','-')"/>
		</mads:classification>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=055]">
		<mads:classification>
			<xsl:value-of select="local:subfieldSelect(.,'abcdxyz','-')"/>
		</mads:classification>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=060]">
		<mads:classification>
			<xsl:value-of select="local:subfieldSelect(.,'abcdxyz','-')"/>
		</mads:classification>
	</xsl:template>
	<!-- 2.13	added $2 authority for <classification> ws-->
	<xsl:template match="marc:datafield[@tag=065]">
		<mads:classification>
			<xsl:if test="marc:subfield[@code='2']">
				<xsl:attribute name="authority">
					<xsl:value-of select="marc:subfield[@code='2']"/>
				</xsl:attribute>				
			</xsl:if>
			<xsl:value-of select="local:subfieldSelect(.,'abcdxyz','-')"/>
		</mads:classification>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=070]">
		<mads:classification>
			<xsl:if test="marc:subfield[@code='2']">
				<xsl:attribute name="authority">
					<xsl:value-of select="marc:subfield[@code='2']"/>
				</xsl:attribute>				
			</xsl:if>
			<xsl:value-of select="local:subfieldSelect(.,'abcdxyz5','-')"/>
		</mads:classification>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=080]">
		<mads:classification>
			<xsl:if test="marc:subfield[@code='2']">
				<xsl:attribute name="authority">
					<xsl:value-of select="marc:subfield[@code='2']"/>
				</xsl:attribute>				
			</xsl:if>
			<xsl:value-of select="local:subfieldSelect(.,'abcdxyz5','-')"/>
		</mads:classification>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=082]">
		<mads:classification>
			<xsl:if test="marc:subfield[@code='2']">
				<xsl:attribute name="authority">
					<xsl:value-of select="marc:subfield[@code='2']"/>
				</xsl:attribute>				
			</xsl:if>
			<xsl:value-of select="local:subfieldSelect(.,'abcdxyz5','-')"/>
		</mads:classification>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=083]">
		<mads:classification>
			<xsl:if test="marc:subfield[@code='2']">
				<xsl:attribute name="authority">
					<xsl:value-of select="marc:subfield[@code='2']"/>
				</xsl:attribute>				
			</xsl:if>
			<xsl:value-of select="local:subfieldSelect(.,'abcdxyz5','-')"/>
		</mads:classification>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=086]">
		<mads:classification>
			<xsl:if test="marc:subfield[@code='2']">
				<xsl:attribute name="authority">
					<xsl:value-of select="marc:subfield[@code='2']"/>
				</xsl:attribute>				
			</xsl:if>
			<xsl:value-of select="local:subfieldSelect(.,'abcdxyz5','-')"/>
		</mads:classification>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=087]">
		<mads:classification>
			<xsl:if test="marc:subfield[@code='2']">
				<xsl:attribute name="authority">
					<xsl:value-of select="marc:subfield[@code='2']"/>
				</xsl:attribute>				
			</xsl:if>
			<xsl:value-of select="local:subfieldSelect(.,'abcdxyz5','-')"/>
		</mads:classification>
	</xsl:template>
	
	<!-- ========== affiliation  ========== -->	
	<xsl:template match="marc:datafield[@tag=373]">
		<mads:affiliation>
			<mads:position>
				<xsl:value-of select="marc:subfield[@code='a']"/>
			</mads:position>
			<mads:dateValid point="start">
				<xsl:value-of select="marc:subfield[@code='s']"/>
			</mads:dateValid>
			<mads:dateValid point="end">
				<xsl:value-of select="marc:subfield[@code='t']"/>
			</mads:dateValid>
		</mads:affiliation>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=371]">
		<mads:affiliation>
			<mads:address>
				<mads:street>
					<xsl:value-of select="marc:subfield[@code='a']"/>
				</mads:street>
				<mads:city>
					<xsl:value-of select="marc:subfield[@code='b']"/>
				</mads:city>
				<mads:state>
					<xsl:value-of select="marc:subfield[@code='c']"/>
				</mads:state>
				<mads:country>
					<xsl:value-of select="marc:subfield[@code='d']"/>
				</mads:country>
				<mads:postcode>
					<xsl:value-of select="marc:subfield[@code='e']"/>
				</mads:postcode>
			</mads:address>
			<mads:email>
				<xsl:value-of select="marc:subfield[@code='m']"/>
			</mads:email>
		</mads:affiliation>
	</xsl:template>

	<!-- ========== extension  ========== -->	
	<xsl:template match="marc:datafield[@tag=336]">
		<mads:extension>
			<mads:contentType>
				<mads:contentType type="text">
					<xsl:value-of select="marc:subfield[@code='a']"/>
				</mads:contentType>
				<mads:contentType type="code">
					<xsl:value-of select="marc:subfield[@code='b']"/>
				</mads:contentType>
			</mads:contentType>
		</mads:extension>
	</xsl:template>
	
	<xsl:template match="marc:datafield[@tag=374]">
		<mads:extension>
			<mads:profession>
				<xsl:choose>
					<xsl:when test="marc:subfield[@code='a']">
						<mads:professionTerm>
							<xsl:value-of select="marc:subfield[@code='a']"/>
						</mads:professionTerm>
					</xsl:when>
					<xsl:when test="marc:subfield[@code='s']">
						<mads:dateValid point="start">
							<xsl:value-of select="marc:subfield[@code='s']"/>
						</mads:dateValid>
					</xsl:when>
					<xsl:when test="marc:subfield[@code='t']">
						<mads:dateValid point="end">
							<xsl:value-of select="marc:subfield[@code='t']"/>
						</mads:dateValid>
					</xsl:when>
				</xsl:choose>
			</mads:profession>
		</mads:extension>
	</xsl:template>
	
	<xsl:template match="marc:datafield[@tag=375]">
		<mads:extension>
			<mads:gender>
				<xsl:choose>
					<xsl:when test="marc:subfield[@code='a']">
						<mads:genderTerm>
							<xsl:value-of select="marc:subfield[@code='a']"/>
						</mads:genderTerm>
					</xsl:when>
					<xsl:when test="marc:subfield[@code='s']">
						<mads:dateValid point="start">
							<xsl:value-of select="marc:subfield[@code='s']"/>
						</mads:dateValid>
					</xsl:when>
					<xsl:when test="marc:subfield[@code='t']">
						<mads:dateValid point="end">
							<xsl:value-of select="marc:subfield[@code='t']"/>
						</mads:dateValid>
					</xsl:when>
				</xsl:choose>
			</mads:gender>
		</mads:extension>
	</xsl:template>
	
	<xsl:template match="marc:datafield[@tag=376]">
		<mads:extension>
			<mads:familyInformation>
				<mads:typeOfFamily>
					<xsl:value-of select="marc:subfield[@code='a']"/>
				</mads:typeOfFamily>
				<mads:nameOfProminentMember>
					<xsl:value-of select="marc:subfield[@code='b']"/>
				</mads:nameOfProminentMember>
				<mads:hereditaryTitle>
					<xsl:value-of select="marc:subfield[@code='c']"/>
				</mads:hereditaryTitle>
				<mads:dateValid point="start">
					<xsl:value-of select="marc:subfield[@code='s']"/>
				</mads:dateValid>
				<mads:dateValid point="end">
					<xsl:value-of select="marc:subfield[@code='t']"/>
				</mads:dateValid>
			</mads:familyInformation>
		</mads:extension>
	</xsl:template>
	
	
	<!-- ========== names  ========== -->
	<xsl:template match="marc:datafield[@tag=100]">
		<mads:name type="personal">
			<xsl:call-template name="setAuthority"/>
			<xsl:call-template name="nameABCDQ"/>
		</mads:name>
		<xsl:apply-templates select="*[marc:subfield[not(contains('abcdeq',@code))]]"/>
		<xsl:call-template name="title"/>
		<xsl:apply-templates select="marc:subfield[@code!='i']"/>
	</xsl:template>

	<xsl:template match="marc:datafield[@tag=110]">
		<mads:name type="corporate">
			<xsl:call-template name="setAuthority"/>
			<xsl:call-template name="nameABCDN"/>
		</mads:name>
		<xsl:apply-templates select="marc:subfield[@code!='i']"/>
	</xsl:template>

	<xsl:template match="marc:datafield[@tag=111]">
		<mads:name type="conference">
			<xsl:call-template name="setAuthority"/>
			<xsl:call-template name="nameACDENQ"/>
		</mads:name>
		<xsl:apply-templates select="marc:subfield[@code!='i']"/>
	</xsl:template>

	<xsl:template match="marc:datafield[@tag=400]">
		<mads:variant>
			<xsl:call-template name="variantTypeAttribute"/>
			<mads:name type="personal">
				<xsl:call-template name="nameABCDQ"/>
			</mads:name>
			<xsl:apply-templates select="marc:subfield[@code!='i']"/>
			<xsl:call-template name="title"/>
		</mads:variant>
	</xsl:template>

	<xsl:template match="marc:datafield[@tag=410]">
		<mads:variant>
			<xsl:call-template name="variantTypeAttribute"/>
			<mads:name type="corporate">
				<xsl:call-template name="nameABCDN"/>
			</mads:name>
			<xsl:apply-templates select="marc:subfield[@code!='i']"/>
		</mads:variant>
	</xsl:template>

	<xsl:template match="marc:datafield[@tag=411]">
		<mads:variant>
			<xsl:call-template name="variantTypeAttribute"/>
			<mads:name type="conference">
				<xsl:call-template name="nameACDENQ"/>
			</mads:name>
			<xsl:apply-templates select="marc:subfield[@code!='i']"/>
		</mads:variant>
	</xsl:template>

	<xsl:template match="marc:datafield[@tag=500]|marc:datafield[@tag=700]">
		<mads:related>
			<xsl:call-template name="relatedTypeAttribute"/>
			<!-- <xsl:call-template name="uri"/> -->
			<mads:name type="personal">
				<xsl:call-template name="setAuthority"/>
				<xsl:call-template name="nameABCDQ"/>
			</mads:name>
			<xsl:call-template name="title"/>
			<xsl:apply-templates select="marc:subfield[@code!='i']"/>
		</mads:related>
	</xsl:template>

	<xsl:template match="marc:datafield[@tag=510]|marc:datafield[@tag=710]">
		<mads:related>
			<xsl:call-template name="relatedTypeAttribute"/>
			<!-- <xsl:call-template name="uri"/> -->
			<mads:name type="corporate">
				<xsl:call-template name="setAuthority"/>
				<xsl:call-template name="nameABCDN"/>
			</mads:name>
			<xsl:apply-templates select="marc:subfield[@code!='i']"/>
		</mads:related>
	</xsl:template>

	<xsl:template match="marc:datafield[@tag=511]|marc:datafield[@tag=711]">
		<mads:related>
			<xsl:call-template name="relatedTypeAttribute"/>
			<!-- <xsl:call-template name="uri"/> -->
			<mads:name type="conference">
				<xsl:call-template name="setAuthority"/>
				<xsl:call-template name="nameACDENQ"/>
			</mads:name>
			<xsl:apply-templates select="marc:subfield[@code!='i']"/>
		</mads:related>
	</xsl:template>

	<!-- ========== titles  ========== -->
	<xsl:template match="marc:datafield[@tag=130]">
		<xsl:call-template name="uniform-title"/>
		<xsl:apply-templates select="marc:subfield[@code!='i']"/>
	</xsl:template>

	<xsl:template match="marc:datafield[@tag=430]">
		<mads:variant>
			<xsl:call-template name="variantTypeAttribute"/>
			<xsl:call-template name="uniform-title"/>
			<xsl:apply-templates select="marc:subfield[@code!='i']"/>
		</mads:variant>
	</xsl:template>

	<xsl:template match="marc:datafield[@tag=530]|marc:datafield[@tag=730]">
		<mads:related>
			<xsl:call-template name="relatedTypeAttribute"/>
			<xsl:call-template name="uniform-title"/>
			<xsl:apply-templates select="marc:subfield[@code!='i']"/>
		</mads:related>
	</xsl:template>

	<xsl:template name="title">
		<xsl:variable name="hasTitle">
			<xsl:for-each select="marc:subfield">
				<xsl:if test="(contains('tfghklmors',@code) )">
					<xsl:value-of select="@code"/>
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:if test="string-length($hasTitle) &gt; 0 ">
			<mads:titleInfo>
				<xsl:call-template name="setAuthority"/>
				<mads:title>
					<xsl:value-of select="local:stripPunctuation(local:subfieldSelect(.,'atfghklmors'))"/>
				</mads:title>
				<xsl:call-template name="part"/>
				<!-- <xsl:call-template name="uri"/> -->
			</mads:titleInfo>
		</xsl:if>
	</xsl:template>

	<xsl:template name="uniform-title">
		<xsl:variable name="hasTitle">
			<xsl:for-each select="marc:subfield">
				<xsl:if test="(contains('atfghklmors',@code) )">
					<xsl:value-of select="@code"/>
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:if test="string-length($hasTitle) &gt; 0 ">
			<mads:titleInfo>
				<xsl:call-template name="setAuthority"/>
				<mads:title>
					<xsl:value-of select="local:stripPunctuation(local:subfieldSelect(.,'adfghklmors'))"/>
				</mads:title>
				<xsl:call-template name="part"/>
				<!-- <xsl:call-template name="uri"/> -->
			</mads:titleInfo>
		</xsl:if>
	</xsl:template>


	<!-- ========== topics  ========== -->
	<xsl:template match="marc:subfield[@code='x']">
		<mads:topic>
			<xsl:value-of select="local:stripPunctuation(.)"/>
		</mads:topic>
	</xsl:template>
	
	<!-- 2.06 fix -->
	<xsl:template match="marc:datafield[@tag=150][marc:subfield[@code='a' or @code='b']]|marc:datafield[@tag=180][marc:subfield[@code='x']]">
		<xsl:call-template name="topic"/>
		<xsl:apply-templates select="marc:subfield[@code!='i']"/>
	</xsl:template>
	<xsl:template
		match="marc:datafield[@tag=450][marc:subfield[@code='a' or @code='b']]|marc:datafield[@tag=480][marc:subfield[@code='x']]">
		<mads:variant>
			<xsl:call-template name="variantTypeAttribute"/>
			<xsl:call-template name="topic"/>
		</mads:variant>
	</xsl:template>
	<xsl:template
		match="marc:datafield[@tag=550 or @tag=750][marc:subfield[@code='a' or @code='b']]">
		<mads:related>
			<xsl:call-template name="relatedTypeAttribute"/>
			<!-- <xsl:call-template name="uri"/> -->
			<xsl:call-template name="topic"/>
			<xsl:apply-templates select="marc:subfield[@code='z']"/>
		</mads:related>
	</xsl:template>
	<xsl:template name="topic">
		<mads:topic>
			<xsl:call-template name="setAuthority"/>
			<!-- tmee2006 dedupe 550a
			<xsl:if test="@tag=550 or @tag=750">
				<xsl:call-template name="subfieldSelect">
					<xsl:with-param name="codes">ab</xsl:with-param>
				</xsl:call-template>
			</xsl:if>	
			-->
			<xsl:choose>
				<xsl:when test="@tag=180 or @tag=480 or @tag=580 or @tag=780">		
					<xsl:apply-templates select="local:stripPunctuation(local:subfieldSelect(.,'x'))"/>
				</xsl:when>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="@tag=180 or @tag=480 or @tag=580 or @tag=780">
					<xsl:apply-templates select="local:stripPunctuation(local:subfieldSelect(.,'x'))"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="local:stripPunctuation(local:subfieldSelect(.,'ab'))"/>
				</xsl:otherwise>
			</xsl:choose>
		</mads:topic>
	</xsl:template>

	<!-- ========= temporals  ========== -->
	<xsl:template match="marc:subfield[@code='y']">
		<mads:temporal>
			<xsl:value-of select="local:stripPunctuation(.)"/>
		</mads:temporal>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=148][marc:subfield[@code='a']]|marc:datafield[@tag=182 ][marc:subfield[@code='y']]">
		<xsl:call-template name="temporal"/>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=448][marc:subfield[@code='a']]|marc:datafield[@tag=482][marc:subfield[@code='y']]">
		<mads:variant>
			<xsl:call-template name="variantTypeAttribute"/>
			<xsl:call-template name="temporal"/>
		</mads:variant>
	</xsl:template>
	<xsl:template
		match="marc:datafield[@tag=548 or @tag=748][marc:subfield[@code='a']]|marc:datafield[@tag=582 or @tag=782][marc:subfield[@code='y']]">
		<mads:related>
			<xsl:call-template name="relatedTypeAttribute"/>
			<!-- <xsl:call-template name="uri"/> -->
			<xsl:call-template name="temporal"/>
		</mads:related>
	</xsl:template>
	<xsl:template name="temporal">
		<mads:temporal>
			<xsl:call-template name="setAuthority"/>
			<xsl:if test="@tag=548 or @tag=748">
				<xsl:value-of select="marc:subfield[@code='a']"/>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="@tag=182 or @tag=482 or @tag=582 or @tag=782">
					<xsl:apply-templates select="local:stripPunctuation(local:subfieldSelect(.,'y'))"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="local:stripPunctuation(local:subfieldSelect(.,'a'))"/>
				</xsl:otherwise>
			</xsl:choose>
		</mads:temporal>
		<xsl:apply-templates select="marc:subfield[@code!='i']"/>
	</xsl:template>

	<!-- ========== genre  ========== -->
	<xsl:template match="marc:subfield[@code='v']">
		<mads:genre>
			<xsl:value-of select="local:stripPunctuation(.)"/>
		</mads:genre>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=155][marc:subfield[@code='a']]|marc:datafield[@tag=185][marc:subfield[@code='v']]">
		<xsl:call-template name="genre"/>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=455][marc:subfield[@code='a']]|marc:datafield[@tag=485 ][marc:subfield[@code='v']]">
		<mads:variant>
			<xsl:call-template name="variantTypeAttribute"/>
			<xsl:call-template name="genre"/>
		</mads:variant>
	</xsl:template>
	<!--
	<xsl:template match="marc:datafield[@tag=555]">
		<mads:related>
			<xsl:call-template name="relatedTypeAttribute"/>
			<xsl:call-template name="uri"/>
			<xsl:call-template name="genre"/>
		</mads:related>
	</xsl:template>
	-->
	<xsl:template
		match="marc:datafield[@tag=555 or @tag=755][marc:subfield[@code='a']]|marc:datafield[@tag=585][marc:subfield[@code='v']]">
		<mads:related>
			<xsl:call-template name="relatedTypeAttribute"/>
			<xsl:call-template name="genre"/>
		</mads:related>
	</xsl:template>
	<xsl:template name="genre">
		<mads:genre>
			<xsl:if test="@tag=555">
				<xsl:value-of select="marc:subfield[@code='a']"/>
			</xsl:if>
			<xsl:call-template name="setAuthority"/>

			<xsl:choose>
				<!-- 2.07 fix -->
				<xsl:when test="@tag='555'"/>
				<xsl:when test="@tag=185 or @tag=485 or @tag=585">
					<xsl:apply-templates select="local:stripPunctuation(local:subfieldSelect(.,'v'))"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="local:stripPunctuation(local:subfieldSelect(.,'a'))"/>
				</xsl:otherwise>
			</xsl:choose>
		</mads:genre>
		<xsl:apply-templates/>
	</xsl:template>

	<!-- ========= geographic  ========== -->
	<xsl:template match="marc:subfield[@code='z']">
		<mads:geographic>
			<xsl:value-of select="local:stripPunctuation(.)"/>
		</mads:geographic>
	</xsl:template>
	<xsl:template name="geographic">
		<mads:geographic>
			<!-- 2.14 -->
			<xsl:call-template name="setAuthority"/>
			<xsl:if test="@tag=151 or @tag=551">
				<xsl:value-of select="marc:subfield[@code='a'][1]"/>
			</xsl:if>
			<xsl:if test="@tag=181 or @tag=481 or @tag=581">
				<xsl:apply-templates select="local:stripPunctuation(local:subfieldSelect(.,'z'))"/>
			</xsl:if>
		</mads:geographic>
		<xsl:apply-templates select="marc:subfield[@code!='i']"/>
	</xsl:template>
	<xsl:template
		match="marc:datafield[@tag=151][marc:subfield[@code='a']]|marc:datafield[@tag=181][marc:subfield[@code='z']]">
		<xsl:call-template name="geographic"/>
	</xsl:template>
	<xsl:template
		match="marc:datafield[@tag=451][marc:subfield[@code='a']]|marc:datafield[@tag=481][marc:subfield[@code='z']]">
		<mads:variant>
			<xsl:call-template name="variantTypeAttribute"/>
			<xsl:call-template name="geographic"/>
		</mads:variant>
	</xsl:template>
	<xsl:template
		match="marc:datafield[@tag=551]|marc:datafield[@tag=581][marc:subfield[@code='z']]">
		<mads:related>
			<xsl:call-template name="relatedTypeAttribute"/>
			<!-- <xsl:call-template name="uri"/> -->
			<xsl:call-template name="geographic"/>
		</mads:related>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=580]">
		<mads:related>
			<xsl:call-template name="relatedTypeAttribute"/>
			<xsl:apply-templates select="marc:subfield[@code!='i']"/>
		</mads:related>
	</xsl:template>
	<xsl:template
		match="marc:datafield[@tag=751][marc:subfield[@code='z']]|marc:datafield[@tag=781][marc:subfield[@code='z']]">
		<mads:related>
			<xsl:call-template name="relatedTypeAttribute"/>
			<xsl:call-template name="geographic"/>
		</mads:related>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=755]">
		<mads:related>
			<xsl:call-template name="relatedTypeAttribute"/>
			<xsl:call-template name="genre"/>
			<xsl:call-template name="setAuthority"/>
			<xsl:apply-templates select="marc:subfield[@code!='i']"/>
		</mads:related>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=780]">
		<mads:related>
			<xsl:call-template name="relatedTypeAttribute"/>
			<xsl:apply-templates select="marc:subfield[@code!='i']"/>
		</mads:related>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=785]">
		<mads:related>
			<xsl:call-template name="relatedTypeAttribute"/>
			<xsl:apply-templates select="marc:subfield[@code!='i']"/>
		</mads:related>
	</xsl:template>

	<!-- ========== notes  ========== -->
	<xsl:template match="marc:datafield[667 &lt;= @tag and @tag &lt;= 688]">
		<mads:note>
			<xsl:choose>
				<xsl:when test="@tag=667">
					<xsl:attribute name="type">nonpublic</xsl:attribute>
				</xsl:when>
				<xsl:when test="@tag=670">
					<xsl:attribute name="type">source</xsl:attribute>
				</xsl:when>
				<xsl:when test="@tag=675">
					<xsl:attribute name="type">notFound</xsl:attribute>
				</xsl:when>
				<xsl:when test="@tag=678">
					<xsl:attribute name="type">history</xsl:attribute>
				</xsl:when>
				<xsl:when test="@tag=681">
					<xsl:attribute name="type">subject example</xsl:attribute>
				</xsl:when>
				<xsl:when test="@tag=682">
					<xsl:attribute name="type">deleted heading information</xsl:attribute>
				</xsl:when>
				<xsl:when test="@tag=688">
					<xsl:attribute name="type">application history</xsl:attribute>
				</xsl:when>
			</xsl:choose>
			<xsl:choose>			
				<xsl:when test="@tag=667 or @tag=675">
					<xsl:value-of select="local:stripPunctuation(local:subfieldSelect(.,'a'))"/>
				</xsl:when>
				<xsl:when test="@tag=670 or @tag=678">
					<xsl:value-of select="local:stripPunctuation(local:subfieldSelect(.,'ab'))"/>
				</xsl:when>
				<xsl:when test="680 &lt;= @tag and @tag &lt;=688">
					<xsl:value-of select="local:stripPunctuation(local:subfieldSelect(.,'ai'))"/>
				</xsl:when>
			</xsl:choose>
		</mads:note>
	</xsl:template>

	<!-- ========== url  ========== -->
	<xsl:template match="marc:datafield[@tag=856][marc:subfield[@code='u']]">
		<mads:url>
			<xsl:if test="marc:subfield[@code='z' or @code='3']">
				<xsl:attribute name="displayLabel">
					<xsl:value-of select="local:subfieldSelect(.,'z3')"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:value-of select="marc:subfield[@code='u']"/>
		</mads:url>
	</xsl:template>

	<xsl:template name="relatedTypeAttribute">
		<xsl:choose>
			<xsl:when
				test="@tag=500 or @tag=510 or @tag=511 or @tag=548 or @tag=550 or @tag=551 or @tag=555 or @tag=580 or @tag=581 or @tag=582 or @tag=585">
				<xsl:if test="substring(marc:subfield[@code='w'],1,1)='a'">
					<xsl:attribute name="type">earlier</xsl:attribute>
				</xsl:if>
				<xsl:if test="substring(marc:subfield[@code='w'],1,1)='b'">
					<xsl:attribute name="type">later</xsl:attribute>
				</xsl:if>
				<xsl:if test="substring(marc:subfield[@code='w'],1,1)='t'">
					<xsl:attribute name="type">parentOrg</xsl:attribute>
				</xsl:if>
				<xsl:if test="substring(marc:subfield[@code='w'],1,1)='g'">
					<xsl:attribute name="type">broader</xsl:attribute>
				</xsl:if>
				<xsl:if test="substring(marc:subfield[@code='w'],1,1)='h'">
					<xsl:attribute name="type">narrower</xsl:attribute>
				</xsl:if>
				<xsl:if test="substring(marc:subfield[@code='w'],1,1)='r'">
					<xsl:attribute name="type">other</xsl:attribute>
				</xsl:if>
				<xsl:if test="contains('fin|', substring(marc:subfield[@code='w'],1,1))">
					<xsl:attribute name="type">other</xsl:attribute>
				</xsl:if>
			</xsl:when>
			<xsl:when test="@tag=530 or @tag=730">
				<xsl:attribute name="type">other</xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<!-- 7xx -->
				<xsl:attribute name="type">equivalent</xsl:attribute>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:apply-templates select="marc:subfield[@code='i']"/>
	</xsl:template>

	<xsl:template name="variantTypeAttribute">
		<xsl:choose>
			<xsl:when
				test="@tag=400 or @tag=410 or @tag=411 or @tag=451 or @tag=455 or @tag=480 or @tag=481 or @tag=482 or @tag=485">
				<xsl:if test="substring(marc:subfield[@code='w'],1,1)='d'">
					<xsl:attribute name="type">acronym</xsl:attribute>
				</xsl:if>
				<xsl:if test="substring(marc:subfield[@code='w'],1,1)='n'">
					<xsl:attribute name="type">other</xsl:attribute>
				</xsl:if>
				<xsl:if test="contains('fit', substring(marc:subfield[@code='w'],1,1))">
					<xsl:attribute name="type">other</xsl:attribute>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<!-- 430  -->
				<xsl:attribute name="type">other</xsl:attribute>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:apply-templates select="marc:subfield[@code='i']"/>
	</xsl:template>

	<xsl:template name="setAuthority">
		<xsl:variable name="controlField008-11" select="substring(ancestor-or-self::marc:record/marc:controlfield[@tag=008],12,1)"/>
		<xsl:variable name="controlField008-14" select="substring(ancestor-or-self::marc:record/marc:controlfield[@tag=008],15,1)"/>
		<xsl:choose>
			<!-- can be called from the datafield or subfield level, so "..//@tag" means
			the tag can be at the subfield's parent level or at the datafields own level -->
			<xsl:when
				test="ancestor-or-self::marc:datafield/@tag=100 and (@ind1=0 or @ind1=1) and $controlField008-11='a' and $controlField008-14='a'">
				<xsl:attribute name="authority">
					<xsl:text>naf</xsl:text>
				</xsl:attribute>
			</xsl:when>
			<xsl:when
				test="ancestor-or-self::marc:datafield/@tag=100 and (@ind1=0 or @ind1=1) and $controlField008-11='a' and $controlField008-14='b'">
				<xsl:attribute name="authority">
					<xsl:text>lcsh</xsl:text>
				</xsl:attribute>
			</xsl:when>
			<xsl:when
				test="ancestor-or-self::marc:datafield/@tag=100 and (@ind1=0 or @ind1=1) and $controlField008-11='k'">
				<xsl:attribute name="authority">
					<xsl:text>lacnaf</xsl:text>
				</xsl:attribute>
			</xsl:when>
			<xsl:when
				test="ancestor-or-self::marc:datafield/@tag=100 and @ind1=3 and $controlField008-11='a' and $controlField008-14='b'">
				<xsl:attribute name="authority">
					<xsl:text>lcsh</xsl:text>
				</xsl:attribute>
			</xsl:when>
			<xsl:when
				test="ancestor-or-self::marc:datafield/@tag=100 and @ind1=3 and $controlField008-11='k' and $controlField008-14='b'">
				<xsl:attribute name="authority">cash</xsl:attribute>
			</xsl:when>
			<xsl:when
				test="ancestor-or-self::marc:datafield/@tag=110 and $controlField008-11='a' and $controlField008-14='a'">
				<xsl:attribute name="authority">naf</xsl:attribute>
			</xsl:when>
			<xsl:when
				test="ancestor-or-self::marc:datafield/@tag=110 and $controlField008-11='a' and $controlField008-14='b'">
				<xsl:attribute name="authority">lcsh</xsl:attribute>
			</xsl:when>
			<xsl:when
				test="ancestor-or-self::marc:datafield/@tag=110 and $controlField008-11='k' and $controlField008-14='a'">
				<xsl:attribute name="authority">
					<xsl:text>lacnaf</xsl:text>
				</xsl:attribute>
			</xsl:when>
			<xsl:when
				test="ancestor-or-self::marc:datafield/@tag=110 and $controlField008-11='k' and $controlField008-14='b'">
				<xsl:attribute name="authority">
					<xsl:text>cash</xsl:text>
				</xsl:attribute>
			</xsl:when>
			<xsl:when
				test="100 &lt;= ancestor-or-self::marc:datafield/@tag and ancestor-or-self::marc:datafield/@tag &lt;= 155 and $controlField008-11='b'">
				<xsl:attribute name="authority">
					<xsl:text>lcshcl</xsl:text>
				</xsl:attribute>
			</xsl:when>
			<xsl:when
				test="(ancestor-or-self::marc:datafield/@tag=100 or ancestor-or-self::marc:datafield/@tag=110 or ancestor-or-self::marc:datafield/@tag=111 or ancestor-or-self::marc:datafield/@tag=130 or ancestor-or-self::marc:datafield/@tag=151) and $controlField008-11='c'">
				<xsl:attribute name="authority">
					<xsl:text>nlmnaf</xsl:text>
				</xsl:attribute>
			</xsl:when>
			<xsl:when
				test="(ancestor-or-self::marc:datafield/@tag=100 or ancestor-or-self::marc:datafield/@tag=110 or ancestor-or-self::marc:datafield/@tag=111 or ancestor-or-self::marc:datafield/@tag=130 or ancestor-or-self::marc:datafield/@tag=151) and $controlField008-11='d'">
				<xsl:attribute name="authority">
					<xsl:text>nalnaf</xsl:text>
				</xsl:attribute>
			</xsl:when>
			<xsl:when
				test="100 &lt;= ancestor-or-self::marc:datafield/@tag and ancestor-or-self::marc:datafield/@tag &lt;= 155 and $controlField008-11='r'">
				<xsl:attribute name="authority">
					<xsl:text>aat</xsl:text>
				</xsl:attribute>
			</xsl:when>
			<xsl:when
				test="100 &lt;= ancestor-or-self::marc:datafield/@tag and ancestor-or-self::marc:datafield/@tag &lt;= 155 and $controlField008-11='s'">
				<xsl:attribute name="authority">sears</xsl:attribute>
			</xsl:when>
			<xsl:when
				test="100 &lt;= ancestor-or-self::marc:datafield/@tag and ancestor-or-self::marc:datafield/@tag &lt;= 155 and $controlField008-11='v'">
				<xsl:attribute name="authority">rvm</xsl:attribute>
			</xsl:when>
			<xsl:when
				test="100 &lt;= ancestor-or-self::marc:datafield/@tag and ancestor-or-self::marc:datafield/@tag &lt;= 155 and $controlField008-11='z'">
				<xsl:attribute name="authority">
					<xsl:value-of
						select="../marc:datafield[ancestor-or-self::marc:datafield/@tag=040]/marc:subfield[@code='f']"
					/>
				</xsl:attribute>
			</xsl:when>
			<xsl:when
				test="(ancestor-or-self::marc:datafield/@tag=111 or ancestor-or-self::marc:datafield/@tag=130) and $controlField008-11='a' and $controlField008-14='a'">
				<xsl:attribute name="authority">
					<xsl:text>naf</xsl:text>
				</xsl:attribute>
			</xsl:when>
			<xsl:when
				test="(ancestor-or-self::marc:datafield/@tag=111 or ancestor-or-self::marc:datafield/@tag=130) and $controlField008-11='a' and $controlField008-14='b'">
				<xsl:attribute name="authority">
					<xsl:text>lcsh</xsl:text>
				</xsl:attribute>
			</xsl:when>
			<xsl:when
				test="(ancestor-or-self::marc:datafield/@tag=111 or ancestor-or-self::marc:datafield/@tag=130) and $controlField008-11='k' ">
				<xsl:attribute name="authority">
					<xsl:text>lacnaf</xsl:text>
				</xsl:attribute>
			</xsl:when>
			<xsl:when
				test="(ancestor-or-self::marc:datafield/@tag=148 or ancestor-or-self::marc:datafield/@tag=150  or ancestor-or-self::marc:datafield/@tag=155) and $controlField008-11='a' ">
				<xsl:attribute name="authority">
					<xsl:text>lcsh</xsl:text>
				</xsl:attribute>
			</xsl:when>
			<xsl:when
				test="(ancestor-or-self::marc:datafield/@tag=148 or ancestor-or-self::marc:datafield/@tag=150  or ancestor-or-self::marc:datafield/@tag=155) and $controlField008-11='a' ">
				<xsl:attribute name="authority">
					<xsl:text>lcsh</xsl:text>
				</xsl:attribute>
			</xsl:when>
			<xsl:when
				test="(ancestor-or-self::marc:datafield/@tag=148 or ancestor-or-self::marc:datafield/@tag=150  or ancestor-or-self::marc:datafield/@tag=155) and $controlField008-11='c' ">
				<xsl:attribute name="authority">
					<xsl:text>mesh</xsl:text>
				</xsl:attribute>
			</xsl:when>
			<xsl:when
				test="(ancestor-or-self::marc:datafield/@tag=148 or ancestor-or-self::marc:datafield/@tag=150  or ancestor-or-self::marc:datafield/@tag=155) and $controlField008-11='d' ">
				<xsl:attribute name="authority">
					<xsl:text>nal</xsl:text>
				</xsl:attribute>
			</xsl:when>
			<xsl:when
				test="(ancestor-or-self::marc:datafield/@tag=148 or ancestor-or-self::marc:datafield/@tag=150  or ancestor-or-self::marc:datafield/@tag=155) and $controlField008-11='k' ">
				<xsl:attribute name="authority">
					<xsl:text>cash</xsl:text>
				</xsl:attribute>
			</xsl:when>
			<xsl:when
				test="ancestor-or-self::marc:datafield/@tag=151 and $controlField008-11='a' and $controlField008-14='a'">
				<xsl:attribute name="authority">
					<xsl:text>naf</xsl:text>
				</xsl:attribute>
			</xsl:when>
			<xsl:when
				test="ancestor-or-self::marc:datafield/@tag=151 and $controlField008-11='a' and $controlField008-14='b'">
				<xsl:attribute name="authority">lcsh</xsl:attribute>
			</xsl:when>
			<xsl:when
				test="ancestor-or-self::marc:datafield/@tag=151 and $controlField008-11='k' and $controlField008-14='a'">
				<xsl:attribute name="authority">lacnaf</xsl:attribute>
			</xsl:when>
			<xsl:when
				test="ancestor-or-self::marc:datafield/@tag=151 and $controlField008-11='k' and $controlField008-14='b'">
				<xsl:attribute name="authority">cash</xsl:attribute>
			</xsl:when>
			<xsl:when
				test="(..//ancestor-or-self::marc:datafield/@tag=180 or ..//ancestor-or-self::marc:datafield/@tag=181 or ..//ancestor-or-self::marc:datafield/@tag=182 or ..//ancestor-or-self::marc:datafield/@tag=185) and $controlField008-11='a'">
				<xsl:attribute name="authority">lcsh</xsl:attribute>
			</xsl:when>
			<xsl:when
				test="ancestor-or-self::marc:datafield/@tag=700 and (@ind1='0' or @ind1='1') and @ind2='0'">
				<xsl:attribute name="authority">naf</xsl:attribute>
			</xsl:when>
			<xsl:when
				test="ancestor-or-self::marc:datafield/@tag=700 and (@ind1='0' or @ind1='1') and @ind2='5'">
				<xsl:attribute name="authority">lacnaf</xsl:attribute>
			</xsl:when>
			<xsl:when test="ancestor-or-self::marc:datafield/@tag=700 and @ind1='3' and @ind2='0'">
				<xsl:attribute name="authority">lcsh</xsl:attribute>
			</xsl:when>
			<xsl:when test="ancestor-or-self::marc:datafield/@tag=700 and @ind1='3' and @ind2='5'">
				<xsl:attribute name="authority">cash</xsl:attribute>
			</xsl:when>
			<xsl:when
				test="(700 &lt;= ancestor-or-self::marc:datafield/@tag and ancestor-or-self::marc:datafield/@tag &lt;= 755 ) and @ind2='1'">
				<xsl:attribute name="authority">lcshcl</xsl:attribute>
			</xsl:when>
			<xsl:when
				test="(ancestor-or-self::marc:datafield/@tag=700 or ancestor-or-self::marc:datafield/@tag=710 or ancestor-or-self::marc:datafield/@tag=711 or ancestor-or-self::marc:datafield/@tag=730 or ancestor-or-self::marc:datafield/@tag=751)  and @ind2='2'">
				<xsl:attribute name="authority">nlmnaf</xsl:attribute>
			</xsl:when>
			<xsl:when
				test="(ancestor-or-self::marc:datafield/@tag=700 or ancestor-or-self::marc:datafield/@tag=710 or ancestor-or-self::marc:datafield/@tag=711 or ancestor-or-self::marc:datafield/@tag=730 or ancestor-or-self::marc:datafield/@tag=751)  and @ind2='3'">
				<xsl:attribute name="authority">nalnaf</xsl:attribute>
			</xsl:when>
			<xsl:when
				test="(700 &lt;= ancestor-or-self::marc:datafield/@tag and ancestor-or-self::marc:datafield/@tag &lt;= 755 ) and @ind2='6'">
				<xsl:attribute name="authority">rvm</xsl:attribute>
			</xsl:when>
			<xsl:when
				test="(700 &lt;= ancestor-or-self::marc:datafield/@tag and ancestor-or-self::marc:datafield/@tag &lt;= 755 ) and @ind2='7'">
				<xsl:attribute name="authority">
					<xsl:value-of select="marc:subfield[@code='2']"/>
				</xsl:attribute>
			</xsl:when>
			<xsl:when
				test="(ancestor-or-self::marc:datafield/@tag=710 or ancestor-or-self::marc:datafield/@tag=711 or ancestor-or-self::marc:datafield/@tag=730 or ancestor-or-self::marc:datafield/@tag=751)  and @ind2='5'">
				<xsl:attribute name="authority">lacnaf</xsl:attribute>
			</xsl:when>
			<xsl:when
				test="(ancestor-or-self::marc:datafield/@tag=710 or ancestor-or-self::marc:datafield/@tag=711 or ancestor-or-self::marc:datafield/@tag=730 or ancestor-or-self::marc:datafield/@tag=751)  and @ind2='0'">
				<xsl:attribute name="authority">naf</xsl:attribute>
			</xsl:when>
			<xsl:when
				test="(ancestor-or-self::marc:datafield/@tag=748 or ancestor-or-self::marc:datafield/@tag=750 or ancestor-or-self::marc:datafield/@tag=755)  and @ind2='0'">
				<xsl:attribute name="authority">lcsh</xsl:attribute>
			</xsl:when>
			<xsl:when
				test="(ancestor-or-self::marc:datafield/@tag=748 or ancestor-or-self::marc:datafield/@tag=750 or ancestor-or-self::marc:datafield/@tag=755)  and @ind2='2'">
				<xsl:attribute name="authority">mesh</xsl:attribute>
			</xsl:when>
			<xsl:when
				test="(ancestor-or-self::marc:datafield/@tag=748 or ancestor-or-self::marc:datafield/@tag=750 or ancestor-or-self::marc:datafield/@tag=755)  and @ind2='3'">
				<xsl:attribute name="authority">nal</xsl:attribute>
			</xsl:when>
			<xsl:when
				test="(ancestor-or-self::marc:datafield/@tag=748 or ancestor-or-self::marc:datafield/@tag=750 or ancestor-or-self::marc:datafield/@tag=755)  and @ind2='5'">
				<xsl:attribute name="authority">cash</xsl:attribute>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="*"/>
</xsl:stylesheet>
