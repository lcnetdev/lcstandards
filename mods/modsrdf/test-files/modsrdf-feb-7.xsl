<?xml version="1.0" encoding="UTF-8"?>
<!-- 
stylesheet to convert a MODS XML (version 3.x) record to RDF
Ray Denenberg, Library of Congess
                                                         -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:mods="http://www.loc.gov/mods/v3" xmlns:modsrdf="http://www.loc.gov/mods/rdf/v1#" xmlns:madsrdf="http://www.loc.gov/mads/rdf/v1#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:identifier="http://id.loc.gov/vocabulary/identifier/" xmlns:relator="http://id.loc.gov/vocabulary/relator/" xmlns:note="http://id.loc.gov/vocabulary/note/" xmlns:abstract="http://id.loc.gov/vocabulary/abstract/" xmlns:access="http://id.loc.gov/vocabulary/access/" xmlns:class="http://id.loc.gov/vocabulary/class/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:ri="http://id.loc.gov/ontologies/RecordInfo#">
	<xsl:output method="xml" indent="yes"/>
	<!-- 
*******************************************
      Global Variables -->
	<!-- 
a new line	 -->
	<xsl:variable name="newline">
		<xsl:text>
</xsl:text>
	</xsl:variable>
	<!-- 
a line break	 -->
	<xsl:variable name="linebreak">
		<xsl:comment>
		
</xsl:comment>
	</xsl:variable>
	<!-- 
a space -->
	<xsl:variable name="space">
		<xsl:text>  </xsl:text>
	</xsl:variable>
	<!-- 
the string "yes"-->
	<xsl:variable name="yes">
		<xsl:text>yes</xsl:text>
	</xsl:variable>
	<!-- 
the string "no"-->
	<xsl:variable name="no">
		<xsl:text>no</xsl:text>
	</xsl:variable>
	<!--- 
***********************************************************
global variables for primary title and principal name 

primary title is the title with usage="primary", 
intended for primary display.

principal name is the name used in a nameTitle.

Rules and definitions:

Primary title :   
A title is the  primary title if and only if it has attribute 'usage' (whose only defined value is "primary"). "Primary", otherwise, has no defined semantics. A primary title could be the uniform title, the principle title (see next) or an abbreviated, translated, etc. title.   There should be at most one primary title (though this is not validated).

Principal title:
A title is the principle title if and only if there is no 'type' attribute. There should be at most one principle title (though this is not validated).

Principal name:
There is at most one principle name, determined as follows.
- If a name has attribute 'usage' (whose only defined value is "primary") it is determined to be the principal name. (There should be at most one name with attribute 'usage" though this is not validated).
- If there is no name with attribute 'usage', and there is exactly one name with role="creator", than that name is the principal name. 
- If there is no name with attribute 'usage', and there is either more than one or no name with role="creator" then there is no principal name.

nameTitle:
If there is a uniflorm title (there should be no more than one, though this is not validated), and if there is a principal name, then a mads nameTitle is constructed using the uniform title and principal name. Otherwise no nameTitle is constructed. Thus (1) if there is a uniform title but no principal name, a mads title (not nameTitle) is constructed from the uniform title; and (2) for any title other than uniform, an mads title is constructed. 

***********************************************************
-->
	<!--
Id for primary title 
-->
	<xsl:variable name="primaryTitleIdentifier" select="generate-id()"/>
	<!--
Id for principal name
-->
	<xsl:variable name="principalNameIdentifier" select="generate-id()"/>
	<!-- 
Generate principal name string (for use in nameTitle)
-->
	<xsl:variable name="principalNameString">
		<xsl:for-each select="/mods:mods/mods:name">
			<xsl:if test="@usage 
					        or 
    			                (mods:role[mods:roleTerm='creator']  
				                and count(/mods:mods/mods:name/mods:role[mods:roleTerm='creator'])=1 
				                and not(/mods:mods/mods:name/@usage))">
				<xsl:apply-templates select="." mode="nameString"/>
			</xsl:if>
		</xsl:for-each>
	</xsl:variable>
	<!-- 
    End  Global Variables 
	 ******************************************* 
	-->
	<xsl:template match="/">
		<!--  
        Root element:
-->
		<rdf:RDF>
			<!--
******************************************************************************************************************************************************
******************************************************************************************************************************************************
MODS record is transformed in the following steps:

1. Generate top-level triple
2. Generate an rdf:type  statement for each resource type
3. Process  names
4. Process  titles, including nameTitles
5. Process identifiers (all except type="modsIdentifier" )
6. Process subjects
7. Process genres (non subject)
8.Process all remaining elements except relatedItem and recordInfo
9. Process administrative metadata (recordInfo)
10. Process the relatedItems


******************************************************************************************************************************************************
******************************************************************************************************************************************************

****************************************************************
*                                                                              *
*             1. Generate top-level triple                           *
*                                                                              *
****************************************************************

The followng generates an element of the form

	<modsrdf:ModsResource rdf:about="MODS12345">

representing the triple   "MODS12345  a ModsResource"

This requires that an identifier of type 'modsIdentifier' has been added to the MODS record, explicitly for this purpose. For the above example the following would be added to the MODS record:

	<identifier type="modsIdentifier">MODS12345</identifier>
-->
			<xsl:comment>
*******************************************************
   Top level element
*******************************************************
</xsl:comment>
			<xsl:variable name="modsIdentifier">
				<xsl:choose>
					<xsl:when test="/mods:mods/mods:identifier[@type='modsIdentifier']">
						<xsl:apply-templates select="/mods:mods/mods:identifier[@type='modsIdentifier']" mode="modsIdentifier"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>http://www.loc.gov/mods/rdf/v1#MODS123456</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:element name="modsrdf:ModsResource">
				<xsl:attribute name="rdf:about"><xsl:value-of select="$modsIdentifier"/></xsl:attribute>
				<xsl:value-of select="$newline"/>
				<!-- 
***********************************************************************************
*                                                                                                      *
*  2. Generate an rdf:type  statement for each resource type                 *
*                                                                                                      *
***********************************************************************************

The followng "xsl:apply-templates"  generates an rdf:type statement for each resourceType, for example:

	<rdf:type rdf:resource="http://id.loc.gov/vocabulary/resourceType#Text"/>

	-->
				<xsl:if test="mods:mods/mods:typeOfResource">
					<xsl:value-of select="$newline"/>
					<xsl:comment>
	
*******************************************************
   rdf:type  statement for each resource type
*******************************************************
</xsl:comment>
					<xsl:apply-templates select="mods:mods/mods:typeOfResource" mode="resourceType"/>
				</xsl:if>
				<!-- 
**************************************************************************************
*                                                                                                         *
*      3. Process  names  (and roles)                                                                      * 
*                                                                                                         *
**************************************************************************************
	-->
				<xsl:if test="/mods:mods/mods:name">
					<xsl:comment>
	*******************************************************
  names
*******************************************************
</xsl:comment>
					<!-- -->
					<xsl:for-each select="/mods:mods/mods:name">
					<xsl:call-template name="nameMainTemplate"/>
					</xsl:for-each>
				</xsl:if>
				<!-- 
**************************************************************************************
*                                                                                                         *
*      4. Process all title elements.                                                         *
*                                                                                                         *
************************************************************************************** -->
				<xsl:if test="/mods:mods/mods:titleInfo">
					<xsl:comment>
	
*******************************************************
  titles
*******************************************************
</xsl:comment>
					<!-- -->
					<xsl:for-each select="/mods:mods/mods:titleInfo">
						<!--
Process uniform and principle  titles (those with no type). Others - abbreviated, etc. - will be treated as variants.
-->
						<xsl:choose>
							<xsl:when test="@type='uniform'">
								<xsl:call-template name="uniformTitle"/>
							</xsl:when>
							<!-- -->
							<xsl:when test="not(@mods:type)">
								<xsl:call-template name="principalTitle"/>
							</xsl:when>
						</xsl:choose>
						<!-- -->
						<xsl:if test="@usage">
							<!-- Process primary title -->
							<xsl:comment>
		
*******  Primary Title
</xsl:comment>
							<!-- -->
							<xsl:element name="hasPrimaryTitle" namespace="http://www.loc.gov/mods/rdf/v1#">
								<xsl:value-of select="$newline"/>
								<xsl:element name="Title" namespace="http://www.loc.gov/mads/rdf/v1#">
									<xsl:attribute name="rdf:about" select="$primaryTitleIdentifier"/>
								</xsl:element>
								<xsl:value-of select="$newline"/>
							</xsl:element>
						</xsl:if>
					</xsl:for-each>
				</xsl:if>
				<!-- 
**************************************************************************************
*                                                                                                         *
*      5. Process  identifiers (all except type="modsIdentifier")                   *
*                                                                                                         *
**************************************************************************************
	-->
				<xsl:if test="mods:mods/mods:identifier[not(@type) or @type!='modsIdentifier']">
					<xsl:comment>

***************************
identifier(s)
***************************
</xsl:comment>
					<xsl:for-each select="mods:mods/mods:identifier">
						<xsl:if test="not(@type) or @type!='modsIdentifier'">
							<xsl:call-template name="identifier"/>
						</xsl:if>
					</xsl:for-each>
				</xsl:if>
				<!-- 
**************************************************************************************
*                                                                                                         *
*      6. Process Subjects
*                                                                                                         *
**************************************************************************************
	-->
				<xsl:if test="mods:mods/mods:subject">
					<xsl:comment>

***************************
subject(s)
***************************
</xsl:comment>
					<xsl:for-each select="mods:mods/mods:subject">
						<xsl:call-template name="subject"/>
						<xsl:value-of select="$newline"/>
					</xsl:for-each>
				</xsl:if>
				<!-- 
**************************************************************************************
*                                                                                                         *
*    7. Process Genres
*                                                                                                         *
**************************************************************************************
	-->
				<xsl:if test="mods:mods/mods:genre">
					<xsl:comment>

***************************
genre(s)
***************************
</xsl:comment>
					<xsl:for-each select="mods:mods/mods:genre">
						<xsl:call-template name="genre"/>
						<xsl:value-of select="$newline"/>
					</xsl:for-each>
				</xsl:if>
				<!-- 
**************************************************************************************
*                                                                                                         *
*      8. Process  remaining elements except recordInfo  and relatedItem   *
*                                                                                                         *
**************************************************************************************
	-->
				<xsl:if test="
    	mods:mods/mods:abstract
or 	mods:mods/mods:accessCondition
or 	mods:mods/mods:classification
or 	mods:mods/mods:language
or 	mods:mods/mods:location
or 	mods:mods/mods:originInfo
or 	mods:mods/mods:note
or 	mods:mods/mods:part
or 	mods:mods/mods:physicalDescription
or 	mods:mods/mods:tableOfContents
or 	mods:mods/mods:targetAudience">
					<xsl:value-of select="$newline"/>
					<xsl:comment>
	
*************************
general elements 
*************************
</xsl:comment>

					<xsl:apply-templates select="/mods:mods" mode="mainElements"/>

				</xsl:if>
				<!--   -->
				<!-- 
****************************************************************
*                                                                              *
*      9.   Process administrative metadata (recordInfo) *
*                                                                              *
****************************************************************
	-->
				<xsl:if test="mods:mods/mods:recordInfo">
					<xsl:value-of select="$newline"/>
					<xsl:comment>
					
********************************  administrative metadata follows  *****************************************		
		
				</xsl:comment>
					<xsl:value-of select="$newline"/>
					<xsl:for-each select="mods:mods/mods:recordInfo">
						<xsl:call-template name="recordInfo"/>
					</xsl:for-each>
				</xsl:if>
				<!--   -->
				<!-- 
****************************************************************
*                                                                              *
*     10.   Process the relatedItems                             *
*                                                                              *
****************************************************************

The followng section  processes all relatedItems.
	-->
				<xsl:if test="mods:mods/mods:relatedItem">
					<xsl:value-of select="$newline"/>
					<xsl:comment>
					
				
********************************  relatedItems follow *****************************************				
				</xsl:comment>
					<xsl:for-each select="mods:mods/mods:relatedItem">
						<xsl:call-template name="relatedItem"/>
						<xsl:value-of select="$newline"/>
					</xsl:for-each>
				</xsl:if>
				<!--
******************************************************************************************************************************************************
******************************************************************************************************************************************************
-->
				<xsl:comment>
**************************************************************
</xsl:comment>
			</xsl:element>
		</rdf:RDF>
	</xsl:template>
	<!--
	*******************************************************************************************************
	
	Templates for each of the MODS top level elements follow, alphabetically.
	
		******************************************************************************************************* -->
	<!--		
********************Template for MODS abstract element
		-->
	<xsl:template match="mods:abstract" mode="mainElements">
		<xsl:comment>

*******abstract
</xsl:comment>
		<modsrdf:hasAbstract>
			<xsl:value-of select="."/>
		</modsrdf:hasAbstract>
		<xsl:value-of select="$newline"/>
	</xsl:template>
	<!--		
********************Template for MODS accessCondition element
		-->
	<xsl:template match="mods:accessCondition" mode="mainElements">
		<xsl:comment>
		
*******accessCondition
</xsl:comment>
		<modsrdf:hasAccessCondition>
			<xsl:value-of select="."/>
		</modsrdf:hasAccessCondition>
		<xsl:value-of select="$newline"/>
	</xsl:template>
	<!--		
********************Template for MODS classification element:
If a classification scheme is supplied (authority attribute), the scheme is used for the property, prefixed by "classification:", for example, "classification:lcc".  If no type, use hasClassification.

		-->
	<xsl:template match="mods:classification" mode="mainElements">
		<xsl:comment>
		
*******classification
</xsl:comment>
		<xsl:variable name="classificationElementName">
			<xsl:choose>
				<xsl:when test="@authority">
					<xsl:value-of select="concat('class:', (@authority))"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>modsrdf:hasClassification</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:element name="{$classificationElementName}">
			<xsl:value-of select="."/>
		</xsl:element>
		<xsl:value-of select="$newline"/>
	</xsl:template>
	<!--		
********************Template for MODS genre element 
		-->
	<xsl:template name="genre">
		<xsl:comment>
		
*******genre
</xsl:comment>
		<modsrdf:hasGenre>
			<GenreForm xmlns="http://www.loc.gov/mads/rdf/v1#">
				<rdf:type rdf:resource="http://www.loc.gov/mads/rdf/v1#GenreForm"/>
				<rdfs:label>
					<xsl:value-of select="."/>
				</rdfs:label>
				<elementList rdf:parseType="Collection">
					<GenreFormElement>
						<elementValue>
							<xsl:value-of select="."/>
						</elementValue>
					</GenreFormElement>
				</elementList>
			</GenreForm>
		</modsrdf:hasGenre>
		<xsl:value-of select="$newline"/>
	</xsl:template>
	<!--		
********************Template for MODS identifer element.
Two modes:
(1) "modsIdentifier".  Special case, when  type = "modsIdentifier", used in the construction of the top level URI. 
(2) "mainIdentifiers". For all others. 
 -->
	<!--
 mode="modsIdentifier"

-->
	<xsl:template match="mods:identifier[@type='modsIdentifier']" mode="modsIdentifier">
		<xsl:value-of select="."/>
	</xsl:template>
	<!--
 mode="mainElements"
 If there is a type, that type is used for the relation, prefixed by "identifier", for example, "identifier:isbn". . If no type, use hasIdentifier.  
-->
	<xsl:template name="identifier">
		<xsl:variable name="identifierElementName">
			<xsl:choose>
				<xsl:when test="@type">
					<xsl:value-of select="concat('identifier:', (@type))"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>modsrdf:hasIdentifier</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:element name="{$identifierElementName}">
			<xsl:value-of select="."/>
		</xsl:element>
		<xsl:value-of select="$newline"/>
	</xsl:template>
	<!--		
********************Template for MODS language element:  
If type="code" a URI is generated; if not, text. 
		-->
	<xsl:template match="mods:language" mode="mainElements">
		<xsl:comment>
		
*******language
</xsl:comment>
		<xsl:value-of select="$newline"/>
		<xsl:for-each select="mods:languageTerm">
			<xsl:choose>
				<xsl:when test="@type='code'">
					<xsl:element name="hasLanguage" namespace="http://www.loc.gov/mods/rdf/v1#">
						<xsl:attribute name="rdf:resource" select="concat('http://id.loc.gov/vocabulary/language#',.)"/>
					</xsl:element>
				</xsl:when>
				<xsl:otherwise>
					<modsrdf:hasLanguageText>
						<xsl:value-of select="."/>
					</modsrdf:hasLanguageText>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:value-of select="$newline"/>
		</xsl:for-each>
	</xsl:template>
	<!--		
********************Template for MODS location element:  
		-->
	<xsl:template match="mods:location" mode="mainElements">
		<xsl:comment>
		
***************location*************
</xsl:comment>
		<xsl:element name="hasLocation" namespace="http://www.loc.gov/mods/rdf/v1#">
			<xsl:element name="Location" namespace="http://www.loc.gov/mods/rdf/v1#">
				<!-- -->
				<xsl:for-each select="mods:physicalLocation">
					<xsl:element name="physicalLocation" namespace="http://www.loc.gov/mods/rdf/v1#">
						<xsl:value-of select="."/>
					</xsl:element>
				</xsl:for-each>
				<!-- -->
				<!-- -->
				<xsl:for-each select="mods:shelfLocator">
					<xsl:element name="shelfLocator" namespace="http://www.loc.gov/mods/rdf/v1#">
						<xsl:value-of select="."/>
					</xsl:element>
				</xsl:for-each>
				<!-- -->
				<xsl:for-each select="mods:url">
					<xsl:element name="url" namespace="http://www.loc.gov/mods/rdf/v1#">
						<xsl:value-of select="."/>
					</xsl:element>
				</xsl:for-each>
				<!-- -->
				<xsl:if test="mods:holdingSimple">
					<xsl:for-each select="mods:holdingSimple/mods:copyInformation">
						<xsl:element name="hasCopy" namespace="http://www.loc.gov/mods/rdf/v1#">
							<xsl:element name="Copy" namespace="http://www.loc.gov/mods/rdf/v1#">
								<!-- -->
								<xsl:if test="mods:form">
									<xsl:element name="form" namespace="http://www.loc.gov/mods/rdf/v1#">
										<xsl:value-of select="mods:form"/>
									</xsl:element>
								</xsl:if>
								<!-- -->
								<xsl:for-each select="mods:subLocation">
									<xsl:element name="subLocation" namespace="http://www.loc.gov/mods/rdf/v1#">
										<xsl:value-of select="."/>
									</xsl:element>
								</xsl:for-each>
								<!-- -->
								<xsl:for-each select="mods:shelfLocator">
									<xsl:element name="shelfLocator" namespace="http://www.loc.gov/mods/rdf/v1#">
										<xsl:value-of select="."/>
									</xsl:element>
								</xsl:for-each>
								<!-- -->
								<xsl:for-each select="mods:electronicLocator">
									<xsl:element name="electronicLocator" namespace="http://www.loc.gov/mods/rdf/v1#">
										<xsl:value-of select="."/>
									</xsl:element>
								</xsl:for-each>
								<!-- -->
								<xsl:for-each select="mods:note">
									<xsl:element name="copyNote" namespace="http://www.loc.gov/mods/rdf/v1#">
										<xsl:value-of select="."/>
									</xsl:element>
								</xsl:for-each>
								<!-- -->
								<xsl:for-each select="mods:enumerationAndChronology">
									<xsl:variable name="enumChronElementName">
										<xsl:choose>
											<xsl:when test="@unitType='1'">
												<xsl:text>enumerationAndChronologyBasic</xsl:text>
											</xsl:when>
											<xsl:when test="@unitType='2'">
												<xsl:text>enumerationAndChronologySupplement</xsl:text>
											</xsl:when>
											<xsl:when test="@unitType='3'">
												<xsl:text>enumerationAndChronologyIndex</xsl:text>
											</xsl:when>
											<xsl:otherwise>
												<xsl:text>enumerationAndChronology</xsl:text>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:variable>
									<xsl:element name="{$enumerationAndChronologyElementName}" namespace="http://www.loc.gov/mods/rdf/v1#">
										<xsl:value-of select="."/>
									</xsl:element>
								</xsl:for-each>
							</xsl:element>
						</xsl:element>
						<!-- unitType is “1” for “basic” , “2” for “supplement” ), or “3” for  “index” -->
					</xsl:for-each>
				</xsl:if>
			</xsl:element>
		</xsl:element>
		<xsl:value-of select="$newline"/>
	</xsl:template>
	<!--		
*******************************************************************************************

Templates for MODS name elements

*******************************************************************************************  
		-->
	<!--		
*******************************
Main NameTemplate
********************************  
		-->
	<xsl:template name="nameMainTemplate">
		<xsl:for-each select=".">
			<!-- -->
			<xsl:variable name="thisIsThePrincipalName">
				<xsl:choose>
					<xsl:when test="
					      @usage 
					         or 
    			                (mods:role[mods:roleTerm='creator']  
				                and count(/mods:mods/mods:name/mods:role[mods:roleTerm='creator'])=1 
				                and not(/mods:mods/mods:name/@usage))">
						<xsl:value-of select="$yes"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$no"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<!-- -->
			<xsl:variable name="nameIdentifier">
				<xsl:choose>
					<xsl:when test="$thisIsThePrincipalName='yes'">
						<xsl:value-of select="$principalNameIdentifier"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="generate-id()"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<!-- -->
			<xsl:variable name="hasNameOrHasPrincipalName">
				<xsl:choose>
					<xsl:when test="$thisIsThePrincipalName='yes'">
						<xsl:text>hasPrincipalName</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>hasName</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<!-- -->
			<xsl:comment>
			** Name **			
			</xsl:comment>
			<xsl:value-of select="$newline"/>
			<xsl:element name="{$hasNameOrHasPrincipalName}" namespace="http://www.loc.gov/mods/rdf/v1#">
				<xsl:value-of select="$newline"/>

				<xsl:call-template name="nameElement">
					<xsl:with-param name="isThisOnePrincipal" select="$thisIsThePrincipalName"/>
					<xsl:with-param name="about" select="$yes"/>
					<xsl:with-param name="nameId" select="$nameIdentifier"/>
				</xsl:call-template>
				<!-- -->
				<xsl:value-of select="$newline"/>
			</xsl:element>
			<!-- 
Process roles.
-->
			<xsl:if test="mods:role">
				<xsl:value-of select="$newline"/>
				<xsl:comment>
**** Roles for this name.
</xsl:comment>
				<xsl:value-of select="$newline"/>
			</xsl:if>
			<!--
 For each role term:

   - if there is an authority, create a property via URI for that role, e.g. relator:creator (where relator is the prefix for http://id.loc.gov/vocabulary/relator/ identifying the LC vocabulary of relators)  where the object of the property is the name.

 - if there is no authority, create a blank node, RoleRelationship, with two properties: (1) role, and (2) name.
-->
			<xsl:for-each select="mods:role">
				<xsl:for-each select="mods:roleTerm">
					<xsl:choose>
						<xsl:when test="@authority">
							<!-- there is an authority -->
							<xsl:variable name="roleParts">
								<xsl:for-each select="tokenize(., '[\s|,|\-]')">
									<xsl:value-of select="concat( upper-case( substring(. , 1 , 1) ) , substring(. , 2 ) )"/>
								</xsl:for-each>
							</xsl:variable>
							<xsl:variable name="Relator" select="string-join($roleParts,' ')"/>
							<xsl:variable name="relator" select="concat(lower-case(substring($Relator, 1 , 1) ) , substring($Relator , 2 ) )"/>
							<!-- -->
							<!-- -->
							<xsl:element name="{concat('relator:',$relator)}">
								<xsl:attribute name="rdf:resource" select="$nameIdentifier"/>
							</xsl:element>
						</xsl:when>
						<xsl:otherwise>
							<modsrdf:hasRoleRelationship>
								<modsrdf:RoleRelationship>
									<modsrdf:role>
										<xsl:value-of select="."/>
									</modsrdf:role>
									<xsl:element name="modsrdf:name">
										<xsl:attribute name="rdf:resource" select="$nameIdentifier"/>
									</xsl:element>
								</modsrdf:RoleRelationship>
							</modsrdf:hasRoleRelationship>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
				<xsl:value-of select="$newline"/>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:template>
	<!--		
******************** Sub Template for name string.  Mode: nameString. 

		-->
	<xsl:template match="mods:name" mode="nameString">
		<xsl:choose>
			<xsl:when test="mods:namePart[not(@type)]">
				<xsl:value-of select="mods:namePart[not(@type)]"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="mods:namePart[@type='termsOfAddress']">
					<xsl:value-of select="mods:namePart[@type='termsOfAddress']"/>
					<xsl:value-of select="$space"/>
				</xsl:if>
				<xsl:value-of select="mods:namePart[@type='given']"/>
				<xsl:value-of select="$space"/>
				<xsl:value-of select="mods:namePart[@type='family']"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:if test="mods:namePart[@type='date']">
			<xsl:value-of select="$space"/>
			<xsl:value-of select="mods:namePart[@type='date']"/>
		</xsl:if>
	</xsl:template>
	<!--		
******************** Sub Template for MODS name element.  Mode: nameElement  This is invoked by the main name element template.
When it is a personal name, the family, given, date, parts are parsed; otherwise, not. 

		-->
	<xsl:template name="nameElement">
		<!--
rdf name element: personalName, corporateName, etc. 
-->
		<xsl:param name="isThisOnePrincipal"/>
		<xsl:param name="about"/>
		<xsl:param name="nameId"/>
		<!-- -->
		<xsl:variable name="nameType">
		<xsl:for-each select="@type">
<xsl:if test=".!='simple'">  <!-- avoid the stupid XLink simple attribute -->
<xsl:value-of select="."/>
</xsl:if>		
		</xsl:for-each>
		
		</xsl:variable> 

		<xsl:variable name="NameType" select="concat( upper-case( substring( $nameType , 1, 1) ) , substring( $nameType , 2 ) )"/>
		<!-- -->
		<xsl:element name="{concat($NameType, 'Name')}" namespace="http://www.loc.gov/mads/rdf/v1#">
			<xsl:if test="$about='yes'">
				<xsl:attribute name="rdf:about" select="$nameId"/>
			</xsl:if>
			<!--  
-->
			<xsl:element name="label" namespace="http://www.w3.org/2000/01/rdf-schema#">
				<xsl:choose>
					<xsl:when test="$isThisOnePrincipal='yes'">
						<xsl:copy-of select="$principalNameString"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="." mode="nameString"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:element>
			<!-- -->
			<xsl:element name="elementList" namespace="http://www.loc.gov/mads/rdf/v1#">
				<xsl:attribute name="rdf:parseType">Collection</xsl:attribute>
				<!-- -->
				<xsl:if test="mods:namePart[not(@type)]">
					<xsl:element name="FullNameElement" namespace="http://www.loc.gov/mads/rdf/v1#">
						<xsl:element name="elementValue" namespace="http://www.loc.gov/mads/rdf/v1#">
							<xsl:value-of select="mods:namePart"/>
						</xsl:element>
					</xsl:element>
				</xsl:if>
				<!-- -->
				<xsl:if test="mods:namePart[@type='family']">
					<xsl:element name="FamilyNameElement" namespace="http://www.loc.gov/mads/rdf/v1#">
						<xsl:element name="elementValue" namespace="http://www.loc.gov/mads/rdf/v1#">
							<xsl:value-of select="mods:namePart[@type='family']"/>
						</xsl:element>
					</xsl:element>
				</xsl:if>
				<!-- -->
				<xsl:if test="mods:namePart[@type='given']">
					<xsl:element name="GivenNameElement" namespace="http://www.loc.gov/mads/rdf/v1#">
						<xsl:element name="elementValue" namespace="http://www.loc.gov/mads/rdf/v1#">
							<xsl:value-of select="mods:namePart[@type='given']"/>
						</xsl:element>
					</xsl:element>
				</xsl:if>
				<!-- -->
				<xsl:if test="mods:namePart[@type='termsOfAddress']">
					<xsl:element name="termsOfAddressNameElement" namespace="http://www.loc.gov/mads/rdf/v1#">
						<xsl:element name="elementValue" namespace="http://www.loc.gov/mads/rdf/v1#">
							<xsl:value-of select="mods:namePart[@type='termsOfAddress']"/>
						</xsl:element>
					</xsl:element>
				</xsl:if>
				<!-- -->
				<xsl:if test="mods:namePart[@type='date']">
					<xsl:element name="DateNameElement" namespace="http://www.loc.gov/mads/rdf/v1#">
						<xsl:element name="elementValue" namespace="http://www.loc.gov/mads/rdf/v1#">
							<xsl:value-of select="mods:namePart[@type='date']"/>
						</xsl:element>
					</xsl:element>
				</xsl:if>
				<!-- -->
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<!--		
********************Template for MODS note element:  
If type is "statement of responsibility" then generate the property 'statementOfResponsibility'. Otherwise, generate 'hasNote' and create blank node when there is a type.
		-->
	<xsl:template match="mods:note" mode="mainElements">
		<xsl:choose>
			<xsl:when test="@type='statement of responsibility'">
				<!-- 
statement of responsibility
-->
				<xsl:comment>
		
*******statement of responsibility
</xsl:comment>
				<xsl:value-of select="$newline"/>
				<modsrdf:hasStatementOfResponsibility>
					<xsl:value-of select="."/>
				</modsrdf:hasStatementOfResponsibility>
			</xsl:when>
			<!-- -->
					<xsl:when  test="count(@type)=1">   <!-- ie. no type attribute, count =1 to account for the stupid XLink simple type -->
				<!-- 
Note  - no type
-->
				<xsl:comment>
		
*******note - no type
</xsl:comment>
				<xsl:value-of select="$newline"/>
				<modsrdf:hasNote>
					<xsl:value-of select="."/>
				</modsrdf:hasNote>
				<xsl:value-of select="$newline"/>
			</xsl:when>
			<xsl:otherwise>
				<!-- 
type other than statementOfResponsibility
-->
				<xsl:comment>
		
*******typed note 
</xsl:comment>
				<xsl:value-of select="$newline"/>
				<modsrdf:hasTypedNote>
					<Note>
						<noteType>
<!-- -->					
						<xsl:variable name="Type">
		<xsl:for-each select="@type">
<xsl:if test=".!='simple'">  <!-- avoid the stupid XLink simple attribute -->
<xsl:value-of select="."/>
</xsl:if>		
		</xsl:for-each>
</xsl:variable>
<!-- -->					
							<xsl:value-of select="type"/>   
						</noteType>
						<noteValue>
							<xsl:value-of select="."/>
						</noteValue>
					</Note>
				</modsrdf:hasTypedNote>
				<xsl:value-of select="$newline"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:value-of select="$newline"/>
	</xsl:template>
	<!--		

********************Template for MODS originInfo element:  
		-->
	<xsl:template match="mods:originInfo" mode="mainElements">
		<xsl:comment>
		
*******Origin
</xsl:comment>
		<xsl:element name="hasOrigin" namespace="http://www.loc.gov/mods/rdf/v1#">
			<xsl:element name="Origin" namespace="http://www.loc.gov/mods/rdf/v1#">
				<xsl:value-of select="$newline"/>
				<xsl:for-each select="./*">
					<xsl:choose>
						<!-- 
                          issuance
                                          -->
						<xsl:when test="local-name()='issuance'">
							<xsl:element name="issuance" namespace="http://www.loc.gov/mods/rdf/v1#">
								<xsl:variable name="issuanceParts">
									<xsl:for-each select="tokenize(., '[\s|,|\-]')">
										<xsl:value-of select="concat( upper-case( substring(. , 1 , 1) ) , substring(. , 2 ) )"/>
									</xsl:for-each>
								</xsl:variable>
								<xsl:variable name="Issuance" select="string-join($issuanceParts,' ')"/>
								<xsl:attribute name="rdf:resource"><xsl:value-of select="concat('http://id.loc.gov/vocabulary/issuance#', lower-case( substring($Issuance, 1 , 1) ) , substring($Issuance, 2 ) )"/></xsl:attribute>
							</xsl:element>
						</xsl:when>
						<!--  
                                     place
                                              -->
						<xsl:when test="local-name()='place'">
							<xsl:for-each select="mods:placeTerm">
								<xsl:element name="place" namespace="http://www.loc.gov/mods/rdf/v1#">
									<xsl:variable name="placeURI">
										<xsl:choose>
											<xsl:when test="@authority='marccountry'">
												<xsl:text>http://id.loc.gov/vocabulary/country#</xsl:text>
											</xsl:when>
											<xsl:otherwise>
												<xsl:if test="@type='code'">
													<xsl:text>http://id.loc.gov/vocabulary/place#</xsl:text>
												</xsl:if>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:variable>
									<xsl:choose>
										<xsl:when test="@type='code' or @authority='marccountry'">
											<xsl:variable name="placeCode">
												<xsl:value-of select="."/>
											</xsl:variable>
											<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($placeURI,$placeCode)"/></xsl:attribute>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="."/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:element>
							</xsl:for-each>
						</xsl:when>
						<!--
                            dates 
                                       -->
						<xsl:when test="contains(local-name(),'Date') or contains(local-name(),'date')">
							<xsl:call-template name="date">
								<xsl:with-param name="elementName" select="local-name()"/>
								<xsl:with-param name="point" select="@point"/>
								<xsl:with-param name="normal" select="@encoding"/>
								<xsl:with-param name="value" select="."/>
								<xsl:with-param name="namespace">http://www.loc.gov/mods/rdf/v1#</xsl:with-param>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<!--
                            other 
                                       -->
							<xsl:element name="{local-name()}" namespace="http://www.loc.gov/mods/rdf/v1#">
								<xsl:value-of select="."/>
							</xsl:element>
							<!-- -->
						</xsl:otherwise>
					</xsl:choose>
					<xsl:value-of select="$newline"/>
				</xsl:for-each>
			</xsl:element>
		</xsl:element>
		<xsl:value-of select="$newline"/>
	</xsl:template>
	<!--   
********************Template for MODS part 
-->
	<xsl:template match="mods:part" mode="mainElements">
		<xsl:comment>
		
*******part
</xsl:comment>
		<xsl:value-of select="$newline"/>
		<xsl:element name="hasPart" namespace="http://www.loc.gov/mods/rdf/v1#">
			<xsl:value-of select="$newline"/>
			<xsl:element name="Part" namespace="http://www.loc.gov/mods/rdf/v1#">
				<xsl:value-of select="$newline"/>
				<!-- create elements for each attribute -->
				<!-- Part - partType -->
				<xsl:if test="@type">
					<xsl:element name="partType" namespace="http://www.loc.gov/mods/rdf/v1#">
						<xsl:value-of select="@type"/>
					</xsl:element>
					<xsl:value-of select="$newline"/>
				</xsl:if>
				<!-- Part - order -->
				<xsl:if test="@order">
					<xsl:element name="order" namespace="http://www.loc.gov/mods/rdf/v1#">
						<xsl:value-of select="@order"/>
					</xsl:element>
					<xsl:value-of select="$newline"/>
				</xsl:if>
				<!-- Part - level -->
				<xsl:if test="mods:detail/@level">
					<xsl:element name="level" namespace="http://www.loc.gov/mods/rdf/v1#">
						<xsl:value-of select="mods:detail/@level"/>
					</xsl:element>
					<xsl:value-of select="$newline"/>
				</xsl:if>
				<!-- Part - extent/@unit -->
				<xsl:if test="mods:extent/@unit">
					<xsl:element name="unit" namespace="http://www.loc.gov/mods/rdf/v1#">
						<xsl:value-of select="mods:extent/@unit"/>
					</xsl:element>
					<xsl:value-of select="$newline"/>
				</xsl:if>
				<!-- Part - detailType -->
				<xsl:if test="mods:detail/@type">
					<xsl:element name="detailType" namespace="http://www.loc.gov/mods/rdf/v1#">
						<xsl:value-of select="mods:detail/@type"/>
					</xsl:element>
					<xsl:value-of select="$newline"/>
				</xsl:if>
				<!--elements -->
				<xsl:for-each select=".//*[not(*)]">
					<xsl:choose>
						<xsl:when test="contains(local-name(),'Date') or contains(local-name(),'date')">
							<xsl:call-template name="date">
								<xsl:with-param name="elementName" select="local-name()"/>
								<xsl:with-param name="point" select="@point"/>
								<xsl:with-param name="normal" select="@encoding"/>
								<xsl:with-param name="value" select="."/>
								<xsl:with-param name="namespace">http://www.loc.gov/mods/rdf/v1#</xsl:with-param>
							</xsl:call-template>
							<xsl:value-of select="$newline"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:element name="{local-name()}" namespace="http://www.loc.gov/mods/rdf/v1#">
								<xsl:value-of select="."/>
							</xsl:element>
							<xsl:value-of select="$newline"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</xsl:element>
			<xsl:value-of select="$newline"/>
		</xsl:element>
		<xsl:value-of select="$newline"/>
	</xsl:template>
	<!--   
********************Template for MODS physicalDescription 

the physicalDescription  in MODS wraps a number of elements, for convenience only, there is no technical reason to bind them together. Therefore the approach here is to define a first-line property for each subelement of physicalDescription, rather than a blank node. 

-->
	<xsl:template match="mods:physicalDescription" mode="mainElements">
		<!-- -->
		<xsl:if test="//mods:physicalDescription">
			<xsl:comment>
		
*************************physical description properties 
</xsl:comment>
			<xsl:for-each select="./*">
				<xsl:value-of select="$newline"/>
				<xsl:variable name="inputElementName" select="local-name()"/>
				<xsl:variable name="outputElementName">
					<xsl:choose>
						<xsl:when test="$inputElementName = 'note'">physicalDescriptionNote	</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$inputElementName"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:element name="{concat('has', upper-case(substring( $outputElementName, 1, 1) ) , substring($outputElementName , 2 ) )}" namespace="http://www.loc.gov/mods/rdf/v1#">
					<xsl:value-of select="."/>
				</xsl:element>
			</xsl:for-each>
			<xsl:value-of select="$newline"/>
		</xsl:if>
	</xsl:template>
	<!--   
********************Template for MODS recordInfo, for administrative metadata
-->
	<xsl:template name="recordInfo">
		<!-- -->
		<xsl:element name="hasAdministrativeMedatata" namespace="http://www.loc.gov/mods/rdf/v1#">
			<xsl:value-of select="$newline"/>
			<xsl:element name="AdministrativeMedatata" namespace="http://id.loc.gov/ontologies/RecordInfo#">
				<xsl:value-of select="$newline"/>
				<xsl:for-each select="child::node()">
					<xsl:choose>
						<!-- 
Language of cataloging
                                       -->
						<xsl:when test="local-name()='languageOfCataloging'">
							<xsl:for-each select="mods:languageTerm">
								<xsl:element name="languageOfCataloging" namespace="http://id.loc.gov/ontologies/RecordInfo#">
									<xsl:choose>
										<xsl:when test="@type='code'">
											<xsl:attribute name="rdf:resource" select="concat('http://id.loc.gov/vocabulary/language#',.)"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="."/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:element>
								<xsl:value-of select="$newline"/>
							</xsl:for-each>
						</xsl:when>
						<!-- 
admin metadata dates
                                       -->
						<xsl:when test="contains(local-name(),'Date')">
							<xsl:call-template name="date">
								<xsl:with-param name="elementName" select="local-name()"/>
								<xsl:with-param name="point" select="@point"/>
								<xsl:with-param name="normal" select="@encoding"/>
								<xsl:with-param name="value" select="."/>
								<xsl:with-param name="namespace">http://id.loc.gov/ontologies/RecordInfo#</xsl:with-param>
							</xsl:call-template>
							<xsl:value-of select="$newline"/>
						</xsl:when>
						<!-- 
remaining admin metadata elements
                                       -->
						<xsl:otherwise>
							<xsl:element name="{local-name()}" namespace="http://id.loc.gov/ontologies/RecordInfo#">
								<xsl:value-of select="."/>
							</xsl:element>
							<xsl:value-of select="$newline"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</xsl:element>
			<xsl:value-of select="$newline"/>
		</xsl:element>
		<xsl:value-of select="$newline"/>
	</xsl:template>
	<!--		
********************Template for MODS relatedItem 
		-->
	<xsl:template name="relatedItem">
		<xsl:comment>
**************relatedItem****************
</xsl:comment>
<!-- -->
<xsl:variable name="Type">
		<xsl:for-each select="@type">
<xsl:if test=".!='simple'">  <!-- avoid the stupid XLink simple attribute -->
<xsl:value-of select="."/>
</xsl:if>		
		</xsl:for-each>
</xsl:variable>
<!-- -->
		<xsl:value-of select="$newline"/>
		<xsl:variable name="relatedItemElementName">
			<xsl:variable name="relatedItemType">
				<xsl:value-of select="concat( upper-case( substring($Type , 1 , 1) ) , substring($Type, 2 ) )"/>
			</xsl:variable>
			<xsl:value-of select="concat('has', $relatedItemType,'RelatedItem')"/>
		</xsl:variable>
		<!-- -->
		<xsl:element name="{$relatedItemElementName}">
			<xsl:value-of select="$newline"/>
			<!-- -->
			<xsl:variable name="relatedIdentifier">
				<xsl:choose>
					<xsl:when test="mods:identifier[$Type='modsIdentifier']">
						<xsl:apply-templates select="mods:identifier[@type='modsIdentifier']" mode="modsIdentifier"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>http://www.loc.gov/mods/rdf/v1#MODS123456</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:element name="modsrdf:ModsResource">
				<xsl:attribute name="rdf:about"><xsl:value-of select="$relatedIdentifier"/></xsl:attribute>
			</xsl:element>
			<xsl:apply-templates select="mods:typeOfResource" mode="resourceType"/>
			<xsl:for-each select="mods:name">
			<xsl:call-template name="nameMainTemplate"/>
			</xsl:for-each>
			<!-- identifiers -->
			<xsl:for-each select="mods:identifier">
				<xsl:if test="not(@type) or @type!='modsIdentifier'">
					<xsl:call-template name="identifier"/>
				</xsl:if>
			</xsl:for-each>
			<!--  titles -->
			<xsl:for-each select="mods:titleInfo">

				<xsl:if  test="count(@type)=1">   <!-- ie. no type attribute, count =1 to account for the stupid XLink simple type -->
				
					<xsl:call-template name="principalTitle"/>
				</xsl:if>
				<xsl:if test="@type='uniform'">
					<xsl:call-template name="uniformTitle"/>
				</xsl:if>
				<!--  -->
			</xsl:for-each>
			<!--  -->
			<xsl:for-each select="mods:genre">
				<xsl:call-template name="genre"/>
				<xsl:value-of select="$newline"/>
			</xsl:for-each>
			<!--  -->
			<!--  -->
			<xsl:for-each select="mods:identifier">
				<xsl:call-template name="identifier"/>
				<xsl:value-of select="$newline"/>
			</xsl:for-each>
			<xsl:apply-templates select="child::node()" mode="mainElements"/>
			<!-- -->
			<xsl:if test="mods:recordInfo">
				<xsl:value-of select="$newline"/>
				<xsl:for-each select="mods:recordInfo">
					<xsl:call-template name="recordInfo"/>
				</xsl:for-each>
			</xsl:if>
		</xsl:element>
		<xsl:value-of select="$newline"/>
	</xsl:template>
	<!--
*******************************************************************************************
Templates for MODS subject follow
******************************************************************************************
-->
	<xsl:template name="subject">
		<xsl:variable name="subjectType">
			<!-- subjectType (small 's') is, for example, 'topic' for <subject><topic>, if there is only one <subject> sublement; otherwise it is 'Complex'. -->
			<xsl:choose>
				<xsl:when test="count(./child::node())=1">
					<xsl:value-of select="local-name(./child::node() )"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>Complex</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!-- -->
		<xsl:variable name="SubjectType">
<xsl:call-template name="getSubjectType">
<xsl:with-param name="subjectType" select="$subjectType"/>
</xsl:call-template>
		</xsl:variable>
		
		<xsl:value-of select="$newline"/>
			<xsl:comment>
				<xsl:value-of select="$newline"/>
				<xsl:value-of select="concat(' ******* subject: ', $subjectType)"/>
				<xsl:value-of select="$newline"/>
			</xsl:comment>
			<xsl:value-of select="$newline"/>
		
		
		<xsl:element name="{concat('has',$SubjectType, 'Subject')}">
			<!-- -->
	
			<xsl:choose>
				<xsl:when test="count(./child::node())=1">
					<xsl:for-each select="./child::node()">
						<xsl:call-template name="subjectSubTemplate">
							<xsl:with-param name="subjectType" select="$subjectType"/>
							<xsl:with-param name="SubjectType" select="$SubjectType"/>
						</xsl:call-template>
					</xsl:for-each>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="complexSubject"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
		<xsl:value-of select="$newline"/>
	</xsl:template>
	<!-- -->
	<xsl:template name="subjectSubTemplate">
		<xsl:param name="subjectType"/>
		<xsl:param name="SubjectType"/>

		<!-- -->
		<!-- -->
		<xsl:call-template name="simpleSubject">
			<xsl:with-param name="SubjType" select="$SubjectType"/>
		</xsl:call-template>
		<xsl:value-of select="$newline"/>
	</xsl:template>
	<!-- -->
	<xsl:template name="simpleSubject">
		<xsl:param name="SubjType"/>
		<!-- -->
		<xsl:choose>
			<xsl:when test="$SubjType='Topic' or $SubjType='Temporal' or $SubjType='Occupation' or $SubjType='GenreForm'">
				<xsl:call-template name="simpleSimpleSubject">
					<xsl:with-param name="subType" select="$SubjType"/>
					<xsl:with-param name="value" select="."/>
				</xsl:call-template>
			</xsl:when>
			<!-- -->
			<xsl:when test="$SubjType='Geographic' or $SubjType='GeographicCode' or $SubjType='Cartographics'">
				<xsl:call-template name="geographic">
					<xsl:with-param name="subType" select="$SubjType"/>
				</xsl:call-template>
			</xsl:when>
			<!-- -->
			<xsl:when test="$SubjType='Title'">
				<xsl:call-template name="subjectTitle"/>
			</xsl:when>
			<xsl:when test="$SubjType='Name'">
				<xsl:call-template name="nameElement">
					<xsl:with-param name="isThisOnePrincipal" select="no"/>
					<xsl:with-param name="about" select="no"/>
					<xsl:with-param name="nameId" select="none"/>
				</xsl:call-template>
			</xsl:when>
			<!-- -->
		</xsl:choose>
	</xsl:template>
	<!--   
******************** simple simple
when there is only a single subelement of subject, and it is flat. 
-->
	<xsl:template name="simpleSimpleSubject">
		<xsl:param name="subType"/>
		<xsl:param name="value"/>

		<xsl:element name="{$subType}" namespace="http://www.loc.gov/mads/rdf/v1#">
			<xsl:value-of select="$newline"/>
			<xsl:element name="label" namespace="http://www.w3.org/2000/01/rdf-schema#">
				<xsl:value-of select="$value"/>
			</xsl:element>
			<xsl:value-of select="$newline"/>
			<xsl:element name="elementList" namespace="http://www.loc.gov/mads/rdf/v1#">
				<xsl:attribute name="rdf:parseType">Collection</xsl:attribute>
				<xsl:element name="{concat($subType,'Element')}" namespace="http://www.loc.gov/mads/rdf/v1#">
					<xsl:element name="elementValue" namespace="http://www.loc.gov/mads/rdf/v1#">
						<xsl:value-of select="$value"/>
					</xsl:element>
				</xsl:element>
			</xsl:element>
			<xsl:value-of select="$newline"/>
		</xsl:element>
	</xsl:template>
	<!--   
********************Template for geographic
-->
	<xsl:template name="geographic">
		<xsl:param name="subType"/>
		<Geographic xmlns="http://www.loc.gov/mads/rdf/v1#">
			<xsl:choose>
				<xsl:when test="$subType='GeographicCode' or $subType='Cartographics'">
					<xsl:text>
PLACE HOLDER for geographicCode or cartographics
</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<rdfs:label>
						<xsl:value-of select="."/>
					</rdfs:label>
					<elementList rdf:parseType="Collection">
						<GeographicElement>
							<elementValue>
								<xsl:value-of select="."/>
							</elementValue>
						</GeographicElement>
					</elementList>
				</xsl:otherwise>
			</xsl:choose>
		</Geographic>
		<xsl:value-of select="$newline"/>
	</xsl:template>
	<!--   
********************Template for subjectTitle
-->
	<xsl:template name="subjectTitle">
		<Title xmlns="http://www.loc.gov/mads/rdf/v1#">
			<xsl:apply-templates mode="titleMainSubTemplate" select="."/>
		</Title>
		<xsl:value-of select="$newline"/>
	</xsl:template>
	<!--   
********************Template for ComplexSubject
-->
	<xsl:template name="complexSubject">
		<ComplexSubject xmlns="http://www.loc.gov/mads/rdf/v1#">
			<!--  have to get the aggregate label -->
			<xsl:value-of select="$newline"/>
			<rdfs:label>
				<xsl:for-each select="*">
					<xsl:choose>
						<xsl:when test="count(child::*) = 0">
							<xsl:value-of select="."/>
							<xsl:text>. </xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:for-each select="*">
								<xsl:value-of select="."/>
								<xsl:text>. </xsl:text>
							</xsl:for-each>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</rdfs:label>
			<xsl:value-of select="$newline"/>
			<!-- -->
			<componentList rdf:parseType="Collection">
				<xsl:value-of select="$newline"/>

<xsl:for-each select="*"> 
	
	<xsl:variable name="subjectType" select="local-name( )"/>

		<xsl:variable name="SubjectType">
<xsl:call-template name="getSubjectType">
<xsl:with-param name="subjectType" select="$subjectType"/>
</xsl:call-template>
		</xsl:variable>

					<xsl:call-template name="subjectSubTemplate">
						<xsl:with-param name="subjectType" select="$subjectType"/>
												<xsl:with-param name="SubjectType" select="$SubjectType"/>
					</xsl:call-template>
				</xsl:for-each>
				<xsl:value-of select="$newline"/>
			</componentList>
			<xsl:value-of select="$newline"/>
		</ComplexSubject>
	</xsl:template>
	
	
<xsl:template name="getSubjectType">
<xsl:param name="subjectType"/> 
			<!-- SubjectType (big 'S' ) converts 'subjectType' (small 's' ) as follows: Converts first letter to upperCase, e.g. 'topic' to 'Topic'. In addition genre becomes GenreForm, titleInfo becomes Title. If there are more than 1 <subject> subelements, or if subjectType is 'ierarchicalGeographic, SubjectType is 'Complex'.	-->
			<xsl:choose>
				<xsl:when test="$subjectType='genre'">
					<xsl:text>GenreForm</xsl:text>
				</xsl:when>
				<xsl:when test="$subjectType='titleInfo'">
					<xsl:text>Title</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="$subjectType!='hierarchicalGeographic'">
							<xsl:value-of select="concat( upper-case( substring($subjectType , 1 , 1) ) , substring($subjectType , 2 ) )"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>Complex</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
</xsl:template>	
	
	
	
	<!--
****************************************
End Templates for MODS subject 
****************************************
-->
	<!-- -->
	<!--   
********************Template for MODS tableOfContents
-->
	<xsl:template match="mods:tableOfContents" mode="mainElements">
		<xsl:comment>
		
******* tableOfContents
</xsl:comment>
		<modsrdf:hasTableOfContents>
			<xsl:value-of select="."/>
		</modsrdf:hasTableOfContents>
		<xsl:value-of select="$newline"/>
	</xsl:template>
	<!--   
********************Template for MODS targetAudience. 
Property generated is hasTargetAudience.  If the authority is "marctarget' then the content is empty and value is expressed as  attribute rdf:resource whose value is the URI for marctarget. Otherwise, the authority is not converted and the value is the content of the element. 
-->
	<xsl:template match="mods:targetAudience" mode="mainElements">
		<xsl:comment>
		
******* targetAudience
</xsl:comment>
		<xsl:choose>
			<xsl:when test="@authority='marctarget'">
				<modsrdf:hasTargetAudience>
					<xsl:variable name="targetAudienceURI">http://id.loc.gov/vocabulary/targetAudience#</xsl:variable>
					<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($targetAudienceURI,.)"/></xsl:attribute>
				</modsrdf:hasTargetAudience>
			</xsl:when>
			<xsl:otherwise>
				<modsrdf:hasTargetAudienceText>
					<xsl:value-of select="."/>
				</modsrdf:hasTargetAudienceText>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:value-of select="$newline"/>
	</xsl:template>
	<!--   
******************************************************************************************
Templates for MODS titleInfo element 
******************************************************************************************
-->
	<!--   
******************** template for uniform title
-->
	<xsl:template name="uniformTitle">
		<xsl:comment>
		
*******uniform title
</xsl:comment>
		<modsrdf:hasUniformTitle>
			<xsl:choose>
				<xsl:when test="/mods:mods/mods:name/@usage or count(/mods:mods/mods:name/mods:role[mods:roleTerm='creator'])=1">
					<!-- there is a principal name, construct a NameTitle -->
					<xsl:call-template name="nameTitle"/>
				</xsl:when>
				<xsl:otherwise>
					<!-- no principal name, just construct a Title -->
					<xsl:call-template name="titlePreliminarySubTemplate"/>
				</xsl:otherwise>
			</xsl:choose>
		</modsrdf:hasUniformTitle>
		<xsl:value-of select="$newline"/>
	</xsl:template>
	<!--   
******************** template for the principal title 
-->
	<xsl:template name="principalTitle">
		<xsl:comment>
		
*******  Principal Title
</xsl:comment>
		<!-- -->
		<xsl:element name="hasPrincipalTitle" namespace="http://www.loc.gov/mods/rdf/v1#">
			<xsl:call-template name="titlePreliminarySubTemplate">
				<xsl:with-param name="principal" select="$yes"/>
			</xsl:call-template>
		</xsl:element>
		<xsl:value-of select="$newline"/>
	</xsl:template>
	<!--   
********************Preliminary Sub Template for MODS titleInfo 
-->
	<xsl:template name="titlePreliminarySubTemplate">
		<xsl:param name="principal"/>
		<xsl:value-of select="$newline"/>
		<xsl:element name="Title" namespace="http://www.loc.gov/mads/rdf/v1#">
			<!-- if it is primary title (usage="primary") attach primary title identifier -->
			<xsl:if test="@usage">
				<xsl:attribute name="rdf:about" select="$primaryTitleIdentifier"/>
			</xsl:if>
			<!-- -->
			<xsl:apply-templates select="." mode="titleMainSubTemplate"/>
			<xsl:if test="$principal='yes'">
				<xsl:for-each select="./../mods:titleInfo">
					<xsl:if test="@type='abbreviated' or @type='translated' or @type='alternative' ">
						<xsl:call-template name="variant"/>
					</xsl:if>
				</xsl:for-each>
			</xsl:if>
			<xsl:value-of select="$newline"/>
		</xsl:element>
		<xsl:value-of select="$newline"/>
	</xsl:template>
	<!--   
********************Main Sub Template for MODS titleInfo 
-->
	<xsl:template match="mods:titleInfo" mode="titleMainSubTemplate">
		<xsl:variable name="labelType">
			<xsl:choose>
								<xsl:when test="@type='abbreviated' or @type='tranlsatated' or @type='alternative'">
					<xsl:value-of>variantLabel</xsl:value-of>
</xsl:when>				
				<xsl:otherwise>
					<xsl:value-of>label</xsl:value-of>
				

				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="labelNamespace">
			<xsl:choose>
				<xsl:when test="$labelType='label'">
					<xsl:text>http://www.w3.org/2000/01/rdf-schema#</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>http://www.loc.gov/mads/rdf/v1#</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!-- -->
		<xsl:value-of select="$newline"/>
		<xsl:element name="{$labelType}" namespace="{$labelNamespace}">
			<xsl:apply-templates select="." mode="titleString"/>
		</xsl:element>
		<xsl:value-of select="$newline"/>
		<xsl:element name="elementList" namespace="http://www.loc.gov/mads/rdf/v1#">
			<xsl:attribute name="rdf:parseType">Collection</xsl:attribute>
			<xsl:value-of select="$newline"/>
			<xsl:if test="mods:nonSort">
				<xsl:element name="nonSortElement" namespace="http://www.loc.gov/mads/rdf/v1#">
					<xsl:element name="elementvalue" namespace="http://www.loc.gov/mads/rdf/v1#">
						<xsl:value-of select="mods:nonSort"/>
					</xsl:element>
				</xsl:element>
			</xsl:if>
			<xsl:value-of select="$newline"/>
			<xsl:element name="mainTitleElement" namespace="http://www.loc.gov/mads/rdf/v1#">
				<xsl:element name="elementValue" namespace="http://www.loc.gov/mads/rdf/v1#">
					<xsl:value-of select="mods:title"/>
				</xsl:element>
			</xsl:element>
			<xsl:value-of select="$newline"/>
			<xsl:if test="mods:subTitle">
				<xsl:element name="SubTitleElement" namespace="http://www.loc.gov/mads/rdf/v1#">
					<xsl:value-of select="$newline"/>
					<xsl:element name="elementValue" namespace="http://www.loc.gov/mads/rdf/v1#">
						<xsl:value-of select="mods:subTitle"/>
					</xsl:element>
					<xsl:value-of select="$newline"/>
				</xsl:element>
					<xsl:value-of select="$newline"/>
			</xsl:if>
			<xsl:if test="mods:partName">
				<xsl:value-of select="$newline"/>
				<xsl:element name="PartNameElement" namespace="http://www.loc.gov/mads/rdf/v1#">
					<xsl:element name="elementValue" namespace="http://www.loc.gov/mads/rdf/v1#">
						<xsl:value-of select="mods:partName"/>
					</xsl:element>
				</xsl:element>
				<xsl:value-of select="$newline"/>
			</xsl:if>
			<xsl:if test="mods:partNumber">
				<xsl:element name="PartNumber" namespace="http://www.loc.gov/mads/rdf/v1#">
					<xsl:element name="elementValue" namespace="http://www.loc.gov/mads/rdf/v1#">
						<xsl:value-of select="mods:partNumber"/>
					</xsl:element>
				</xsl:element>
			</xsl:if>
		</xsl:element>
	</xsl:template>
	<!--   
******************** Sub Template for Title String
-->
	<xsl:template match="mods:titleInfo" mode="titleString">
		<xsl:value-of select="mods:nonSort"/>
		<xsl:if test="mods:nonSort">
			<xsl:value-of select="$space"/>
		</xsl:if>
		<xsl:value-of select="mods:title"/>
		<xsl:if test="mods:subTitle">
			<xsl:text>: </xsl:text>
			<xsl:value-of select="mods:subTitle"/>
		</xsl:if>
		<xsl:if test="mods:partName">
			<xsl:text>. </xsl:text>
			<xsl:value-of select="mods:partName"/>
		</xsl:if>
		<xsl:if test="mods:partNumber">
			<xsl:text>. </xsl:text>
			<xsl:value-of select="mods:partNumber"/>
		</xsl:if>
	</xsl:template>
	<!--   
******************** Sub Template for Title Variants
-->
	<xsl:template name="variant">
		<xsl:variable name="variantElementName">
			<xsl:choose>
				<xsl:when test="@type='abbreviated'">
					<xsl:text>hasAbbreviatedVariant</xsl:text>
				</xsl:when>
				<xsl:when test="@type='translated'">
					<xsl:text>hasTranslatedVariant</xsl:text>
				</xsl:when>
				<xsl:when test="@type='alternative'">
					<xsl:text>hasVariant</xsl:text>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<!-- -->
		<xsl:value-of select="$newline"/>
		<xsl:element name="{$variantElementName}" namespace="http://www.loc.gov/mods/rdf/v1#">
			<xsl:call-template name="titlePreliminarySubTemplate"/>
		</xsl:element>
		<xsl:value-of select="$newline"/>
	</xsl:template>
	<!--   
******************** Template for nameTitle 
-->
	<xsl:template name="nameTitle">
		<!--  -->
		<xsl:value-of select="$newline"/>
		<NameTitle xmlns="http://www.loc.gov/mads/rdf/v1#">
			<rdfs:label>
				<xsl:value-of select="$principalNameString"/>
				<xsl:text> -- </xsl:text>
				<xsl:apply-templates select="/mods:mods/mods:titleInfo[(@type='uniform')]" mode="titleString"/>
			</rdfs:label>
			<componentList rdf:parseType="Collection">
				<xsl:value-of select="$newline"/>
				<!-- 
Get the principal name type  (e.g. "personal")
  -->
				<xsl:variable name="principalNameType">
					<xsl:for-each select="/mods:mods/mods:name">
						<xsl:if test="@usage 
					        or 
    			                (mods:role[mods:roleTerm='creator']  
				                and count(/mods:mods/mods:name/mods:role[mods:roleTerm='creator'])=1 
				                and not(/mods:mods/mods:name/@usage))">
							<xsl:value-of select="@type"/>
						</xsl:if>
					</xsl:for-each>
				</xsl:variable>
				<!-- -->
				<xsl:element name="{concat(upper-case(substring( $principalNameType , 1, 1) ), substring( $principalNameType , 2 ), 'Name' )}" namespace="http://www.loc.gov/mads/rdf/v1#">
					<xsl:attribute name="rdf:about" select="$principalNameIdentifier"/>
				</xsl:element>
				<xsl:call-template name="titlePreliminarySubTemplate"/>
				<xsl:value-of select="$newline"/>
			</componentList>
		</NameTitle>
		<xsl:value-of select="$newline"/>
	</xsl:template>
	<!--   
**************************************************
End templates for MODS titleInfo element 
******************************************************************************************
	   
********************Template for MODS typeOfResource
-->
	<xsl:template match="mods:typeOfResource" mode="resourceType">
		<xsl:value-of select="$newline"/>
		<!-- -->
		<xsl:variable name="resourceTypeURI">http://id.loc.gov/vocabulary/resourceType#</xsl:variable>
		<!-- -->
		<xsl:variable name="resourceTypeParts">
			<xsl:for-each select="tokenize(., '[\s|,|\-]')">
				<xsl:value-of select="concat( upper-case( substring(. , 1 , 1) ) , substring(. , 2 ) )"/>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="resourceTypeClass" select="string-join($resourceTypeParts,' ')"/>
		<xsl:element name="rdf:type">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($resourceTypeURI,$resourceTypeClass)"/></xsl:attribute>
		</xsl:element>
		<!-- -->
		<xsl:if test="@collection">
			<xsl:value-of select="$newline"/>
			<xsl:element name="rdf:type">
				<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($resourceTypeURI,'Collection')"/></xsl:attribute>
			</xsl:element>
		</xsl:if>
		<!-- -->
		<xsl:if test="@manuscript">
			<xsl:value-of select="$newline"/>
			<xsl:element name="rdf:type">
				<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($resourceTypeURI,'Manuscript')"/></xsl:attribute>
			</xsl:element>
		</xsl:if>
		<xsl:value-of select="$newline"/>
	</xsl:template>
	<!--
******************************* 
Auxiliary template for dates
*******************************	
-->
	<xsl:template name="date">
		<xsl:param name="elementName"/>
		<xsl:param name="point"/>
		<xsl:param name="normal"/>
		<xsl:param name="value"/>
		<xsl:param name="namespace"/>
		<!-- -->
		<xsl:variable name="normalized">
			<xsl:choose>
				<xsl:when test="$normal='iso8601' or $normal='w3cdtf' or $normal='marc'">
					<xsl:value-of select="''"/>
				</xsl:when>
				<xsl:otherwise>Text</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!-- -->
		<xsl:variable name="Point" select="concat(upper-case( substring( $point , 1, 1) )  , substring($point , 2 ) )"/>
		<!-- -->
		<xsl:variable name="ElementName">
			<xsl:choose>
				<xsl:when test="$elementName='dateOther'">
					<xsl:text>date</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$elementName"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!-- -->
		<xsl:element name="{concat($ElementName,$Point,$normalized)}" namespace="{$namespace}">
			<xsl:value-of select="$value"/>
		</xsl:element>
		<!-- -->
	</xsl:template>
	<!-- 
*********************************************************
end templates
*********************************************************
-->
	<!--  
The following are added because they seem to fix an xsl problem that generates extraneous output. We are not sure why the extraneous output is generated without these but if we figure it out we will fix the problem and remove these.
-->
	<xsl:template match="mods:typeOfResource" mode="mainElements"/>
	<xsl:template match="mods:titleInfo" mode="mainElements"/>
	<xsl:template match="mods:recordInfo" mode="mainElements"/>
	<xsl:template match="mods:name" mode="mainElements"/>
	<xsl:template match="mods:identifier" mode="mainElements"/>
	<xsl:template match="mods:genre" mode="mainElements"/>
		<xsl:template match="mods:subject" mode="mainElements"/>
	<!--  -->
</xsl:stylesheet>
