<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:marc="http://www.loc.gov/MARC21/slim" xmlns:bf="http://id.loc.gov/ontologies/bibframe/"
                xmlns:bflc="http://id.loc.gov/ontologies/bflc/" xmlns:madsrdf="http://www.loc.gov/mads/rdf/v1#" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="xsl marc">

	<!-- Conversion specs for 3XX -->
	<xsl:include href="../xsl/ConvSpec-3XX.xsl"/>

	<xsl:template match="marc:datafield[@tag='370']" mode="work">
		<xsl:param name="serialization" select="'rdfxml'"/>
		<xsl:apply-templates select="." mode="work370">
			<xsl:with-param name="serialization" select="$serialization"/>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag='370' or @tag='880']" mode="work370">
		<xsl:param name="serialization" select="'rdfxml'"/>

		<xsl:choose>
			<xsl:when test="$serialization = 'rdfxml'">
				<xsl:for-each select="marc:subfield[@code='c' or @code='g']">
					<xsl:variable name="vXmlLang">
						<xsl:apply-templates select="." mode="xmllang"/>
					</xsl:variable>
					<bf:originPlace>
						<bf:Place>
							<rdfs:label>
								<xsl:if test="$vXmlLang != ''">
									<xsl:attribute name="xml:lang">
										<xsl:value-of select="$vXmlLang"/>
									</xsl:attribute>
								</xsl:if>
								<xsl:value-of select="."/>
							</rdfs:label>
						</bf:Place>
					</bf:originPlace>
				</xsl:for-each>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag='377']" mode="work">
		<xsl:param name="serialization" select="'rdfxml'"/>
		<xsl:apply-templates select="." mode="work377">
			<xsl:with-param name="serialization" select="$serialization"/>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag='377' or @tag='880']" mode="work377">
		<xsl:param name="serialization" select="'rdfxml'"/>
		<xsl:choose>
			<xsl:when test="$serialization = 'rdfxml'">
				<xsl:if test="(@ind2!='7' and marc:subfield[@code='a']) or marc:subfield[@code='l' ]">
					<xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
					<bf:language>
						<bf:Language>
							<xsl:choose>
								<xsl:when test="marc:subfield[@code='a' ]">
									<xsl:attribute name="rdf:about">
										<xsl:value-of select="concat($languages, marc:subfield[@code='a'])"/>
									</xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<bf:code>
										<xsl:value-of select="."/>
									</bf:code>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:for-each select="marc:subfield[@code='l' ]">							
								<rdfs:label>
									<xsl:if test="$vXmlLang != ''">
										<xsl:attribute name="xml:lang">
											<xsl:value-of select="$vXmlLang"/>
										</xsl:attribute>
									</xsl:if>
									<xsl:value-of select="."/>
								</rdfs:label>
							</xsl:for-each>
						</bf:Language>
					</bf:language>
				</xsl:if>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
 	
  <xsl:template match="marc:datafield[@tag='381']" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:apply-templates select="." mode="work381">
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>
  </xsl:template>
<!-- 381 auth new -->
  <xsl:template match="marc:datafield[@tag='381' or @tag='880']" mode="work381">
    <xsl:param name="serialization" select="'rdfxml'"/>    
    <xsl:choose>
      <xsl:when test="$serialization='rdfxml'">
      <xsl:if test="marc:subfield[@code='a' or @code='v' or @code='u' ]">
	  <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
          <bf:note>
            <bf:Note>             
              <rdfs:label>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
				<xsl:if test="marc:subfield[@code='a']"><xsl:value-of select="marc:subfield[@code='a']"/></xsl:if>
				<xsl:if test="marc:subfield[@code='v' or @code='u'] ">  -  </xsl:if>
				<xsl:if test="marc:subfield[@code='v']"><xsl:value-of select="marc:subfield[@code='v']"/></xsl:if>
				<xsl:if test="marc:subfield[@code='u'] "><xsl:value-of select="marc:subfield[@code='u']"/></xsl:if>
              </rdfs:label>          			      				
				<xsl:apply-templates select="marc:subfield[@code='2']" mode="subfield2">
              		<xsl:with-param name="serialization" select="$serialization"/>
            	</xsl:apply-templates>
            </bf:Note>
          </bf:note>
    </xsl:if>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
	<!-- 380, 382, 383 use bib spec -->
 

<!--385, 386  auth waiting on wayne's next update for demographicTerms uri 2017-04-05 -->
	
</xsl:stylesheet><!-- Stylus Studio meta-information - (c) 2004-2005. Progress Software Corporation. All rights reserved.
<metaInformation>
<scenarios/><MapperMetaTag><MapperInfo srcSchemaPathIsRelative="yes" srcSchemaInterpretAsXML="no" destSchemaPath="" destSchemaRoot="" destSchemaPathIsRelative="yes" destSchemaInterpretAsXML="no"/><MapperBlockPosition></MapperBlockPosition><TemplateContext></TemplateContext></MapperMetaTag>
</metaInformation>
-->