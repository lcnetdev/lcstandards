<?xml version="1.0" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.loc.gov/MARC21/slim">
	<xsl:template match="/">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="mrcbfile | mrcafile">
		<collection xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.loc.gov/MARC21/slim
		http://www.loc.gov/standards/marcxml/schema/MARC21slim.xsd" >
			<xsl:apply-templates/>
		</collection>
	</xsl:template>

	<xsl:template match="mrcb | mrca">
		<record>
			<xsl:apply-templates select="*[1]"/>
			<xsl:apply-templates select="*[position()&gt;1]/*"/>
		</record>
	</xsl:template>

	<xsl:template match="mrcbldr-bd|mrcbldr-hd|mrcbldr-ci | mrcaldr-ad | mrcaldr-cd">
		<leader>
			<xsl:text>     </xsl:text>
			<xsl:call-template name="blank2space">
				<xsl:with-param name="value" select="child::*[1]/@value"/>
			</xsl:call-template>
			<xsl:call-template name="blank2space">
				<xsl:with-param name="value" select="child::*[2]/@value"/>
			</xsl:call-template>
			<xsl:call-template name="blank2space">
				<xsl:with-param name="value" select="child::*[3]/@value"/>
			</xsl:call-template>
			<xsl:call-template name="blank2space">
				<xsl:with-param name="value" select="child::*[4]/@value"/>
			</xsl:call-template>
			<xsl:call-template name="blank2space">
				<xsl:with-param name="value" select="child::*[5]/@value"/>
			</xsl:call-template>
			<xsl:text>       </xsl:text>
			<xsl:call-template name="blank2space">
				<xsl:with-param name="value" select="child::*[6]/@value"/>
			</xsl:call-template>
			<xsl:call-template name="blank2space">
				<xsl:with-param name="value" select="child::*[7]/@value"/>
			</xsl:call-template>
			<xsl:call-template name="blank2space">
				<xsl:with-param name="value" select="child::*[8]/@value"/>
			</xsl:call-template>
			<xsl:text>    </xsl:text>
		</leader>
	</xsl:template>

	<xsl:template match="mrcb-control-fields/* | mrca-control-fields/*">
		<controlfield tag="{substring(local-name(),5)}">
			<xsl:value-of select="text()"/>
		</controlfield>
	</xsl:template>

	<xsl:template match="mrcb-control-fields/*[*] | mrca-control-fields/*[*]">
		<controlfield tag="{substring(local-name(),5,3)}">
			<xsl:for-each select="*">
				<xsl:variable name="charPos" select="substring(local-name(),12)"/>
				<xsl:choose>
					<xsl:when test="string-length($charPos)=2">
						<xsl:call-template name="convertSubfield">
							<xsl:with-param name="subfieldValue" select="@value"/>
						</xsl:call-template>						
					</xsl:when>
					<xsl:when test="string-length($charPos)=5">
						<xsl:call-template name="convertSubfield">
							<xsl:with-param name="subfieldValue" select="@value"/>
							<xsl:with-param name="stringLength" select="number(substring($charPos,4,2))-number(substring($charPos,1,2))+1"/>
						</xsl:call-template>												
					</xsl:when>
				</xsl:choose>
			</xsl:for-each>
		</controlfield>
	</xsl:template>

	<xsl:template match="*">
		<datafield tag="{substring(local-name(),5)}">
			<xsl:attribute name="ind1">
				<xsl:call-template name="convertIndicator">
					<xsl:with-param name="indicatorValue" select="@i1"/>
				</xsl:call-template>
			</xsl:attribute>
			<xsl:attribute name="ind2">
				<xsl:call-template name="convertIndicator">
					<xsl:with-param name="indicatorValue" select="@i2"/>
				</xsl:call-template>
			</xsl:attribute>
			<xsl:for-each select="*">
				<subfield code="{substring(local-name(),9)}">
					<xsl:value-of select="."/>
				</subfield>
			</xsl:for-each>
		</datafield>
	</xsl:template>

	<xsl:template name="blank2space">
		<xsl:param name="value"/>
		<xsl:choose>
			<xsl:when test="$value='blank'"><xsl:text> </xsl:text></xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$value"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="convertIndicator">
		<xsl:param name="indicatorValue"/>
		<xsl:variable name="choppedValue" select="substring($indicatorValue,4)"/>
		<xsl:choose>
			<xsl:when test="$choppedValue='blank'"><xsl:text> </xsl:text></xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$choppedValue"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="convertSubfield">
		<xsl:param name="subfieldValue"/>
		<xsl:param name="stringLength">1</xsl:param>
		<xsl:choose>
			<xsl:when test="$subfieldValue='blank'">
				<xsl:call-template name="buildSpaces">
					<xsl:with-param name="spaces" select="$stringLength"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$subfieldValue='fill'">|</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="buildSpaces">
					<xsl:with-param name="spaces" select="$stringLength - string-length($subfieldValue)"/>
				</xsl:call-template>
				<xsl:value-of select="$subfieldValue"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="buildSpaces">
		<xsl:param name="spaces"/>
		<xsl:if test="$spaces>0">
			<xsl:text> </xsl:text>
			<xsl:call-template name="buildSpaces">
				<xsl:with-param name="spaces" select="$spaces - 1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet><!-- Stylus Studio meta-information - (c)1998-2003 Copyright Sonic Software Corporation. All rights reserved.
<metaInformation>
<scenarios ><scenario default="no" name="BigtoSlim" userelativepaths="yes" externalpreview="no" url="..\Documents and Settings\jrad\Desktop\test.xml" htmlbaseurl="" outputurl="" processortype="internal" commandline="" additionalpath="" additionalclasspath="" postprocessortype="none" postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext=""/><scenario default="yes" name="bigtoslimb" userelativepaths="yes" externalpreview="no" url="..\Documents and Settings\jrad\Desktop\big.xml" htmlbaseurl="" outputurl="" processortype="internal" commandline="" additionalpath="" additionalclasspath="" postprocessortype="none" postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext=""/></scenarios><MapperInfo srcSchemaPath="" srcSchemaRoot="" srcSchemaPathIsRelative="yes" srcSchemaInterpretAsXML="no" destSchemaPath="" destSchemaRoot="" destSchemaPathIsRelative="yes" destSchemaInterpretAsXML="no"/>
</metaInformation>
-->