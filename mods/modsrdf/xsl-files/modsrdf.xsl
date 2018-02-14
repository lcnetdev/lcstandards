<?xml version="1.0" encoding="UTF-8"?>
<!-- 
stylesheet to convert a MODS XML (version 3.x) record to RDF
Ray Denenberg, Library of Congess

REVISED:  JUNE 7, 2013  (minor errors fixed)


June 7: When links are supplied in the mods xml record, either via XLink or authorityURI,  these should be included in the resultant RDF.  The stylesheet now supports this for names, when  XLink is supplied.  (Will continue to enhance this for remaining cases.)


                                                         -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:mods="http://www.loc.gov/mods/v3" xmlns:modsrdf="http://www.loc.gov/mods/rdf/v1#" xmlns:madsrdf="http://www.loc.gov/mads/rdf/v1#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:identifier="http://id.loc.gov/vocabulary/identifier/" xmlns:relator="http://id.loc.gov/vocabulary/relator/" xmlns:note="http://id.loc.gov/vocabulary/note/" xmlns:abstract="http://id.loc.gov/vocabulary/abstract/" xmlns:access="http://id.loc.gov/vocabulary/access/" xmlns:class="http://id.loc.gov/vocabulary/class/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:ri="http://id.loc.gov/ontologies/RecordInfo#" xmlns:xlink="http://www.w3.org/1999/xlink">
	<xsl:output method="xml" indent="yes"/>
	<!-- 
*******************************************************
                      Global Variables 
******************************************************
-->
	<!-- 
***********************************
identifier lists
**********************************
-->
	<!--
List of identifiers.  Used in identifier template.-->
	<xsl:variable name="identifierList" select="'identifier', 'isbn', 'lccn', 'hdl', 'doi'"/>
	<!-- 

List of classification schemes.  Used in classification template.-->
	<xsl:variable name="classificationSchemeList" select="'class','lcc', 'ddc'"/>
	<!-- 
List of relators (roles).  -->
	<xsl:variable name="relatorsList" select="'act', 'anm', 'art', 'act', 'chr', 'com', 'cre' ,'cre' ,'edt','lyr','pbl' "/>
	<!-- 
***********************************
other global variables
**********************************
-->
	<!-- a new line	 -->
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
					           or (
    			                (mods:role[mods:roleTerm='creator'] or mods:role[mods:roleTerm='cre'] )
				                and count(
				                           /mods:mods/mods:name/mods:role[mods:roleTerm='creator'] 				                           
                                               or			                                                                                                
				                           /mods:mods/mods:name/mods:role[mods:roleTerm='cre'] 				                           
				                           )=1 
				                and not(/mods:mods/mods:name/@usage)
				                )">
				<xsl:call-template name="nameString"/>
			</xsl:if>
		</xsl:for-each>
	</xsl:variable>
	<!---     End  Global Variables 
	 ******************************************* 

Rules and definitions:


Principal title:
A title is the principal title if and only if there is no 'type' attribute. There should be at most one principal title (though this is not validated).

Principal name:
There is at most one principal name, determined as follows.
- If a name has attribute 'usage' (whose only defined value is "primary") it is determined to be the principal name. (There should be at most one name with attribute 'usage" though this is not validated).
- If there is no name with attribute 'usage', and there is exactly one name with role="creator", than that name is the principal name. 
- If there is no name with attribute 'usage', and there is either more than one or no name with role="creator" then there is no principal name.

nameTitle:
If there is a uniflorm title (there should be no more than one, though this is not validated), and if there is a principal name, then a mads nameTitle is constructed using the uniform title and principal name. Otherwise no nameTitle is constructed. Thus (1) if there is a uniform title but no principal name, a mads title (not nameTitle) is constructed from the uniform title; and (2) for any title other than uniform, an mads title is constructed. 

***********************************************************
                   Main Template
***********************************************************
	-->
	<xsl:template match="/mods:mods">
		<!--  
        Root element:
-->
		<rdf:RDF>
				<xsl:comment>

This RDF description created by the stylesheet at http://www.loc.gov/standards/mods/modsrdf/xsl-files/modsrdf.xsl

</xsl:comment>
			<!-- -->
			<xsl:call-template name="modsRecordOrRelatedItem"/>
		</rdf:RDF>
	</xsl:template>
	<!-- 
***********************************************************
                   End Main Template

  Following is template for a MODS record or related item
***********************************************************
-->
	<xsl:template name="modsRecordOrRelatedItem">
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
8. Process simple elements (abstract, accessCondition, tableOfContents, targetAudience)
9. Process all remaining elements except relatedItem and recordInfo
10. Process administrative metadata (recordInfo)
11. Process the relatedItems


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
					<xsl:value-of select="/mods:mods/mods:identifier[@type='modsIdentifier']"/>
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

The followng template call ("resourceType")  generates an rdf:type statement for each resourceType, for example:

	<rdf:type rdf:resource="http://id.loc.gov/vocabulary/resourceType#Text"/>

	-->
			<xsl:if test="mods:typeOfResource">
				<xsl:value-of select="$newline"/>
				<xsl:comment>
	
*******************************************************
   rdf:type  statement for each resource type
*******************************************************
</xsl:comment>
				<xsl:for-each select="mods:typeOfResource">
					<xsl:call-template name="resourceType"/>
				</xsl:for-each>
			</xsl:if>
			<!-- 
**************************************************************************************
*                                                                                                         *
*      3. Process  names  (and roles)                                                                      * 
*                                                                                                         *
**************************************************************************************
	-->
			<xsl:if test="mods:name">
				<xsl:comment>
	*******************************************************
  names
*******************************************************
</xsl:comment>
				<!-- -->
				<xsl:for-each select="mods:name">
					<xsl:call-template name="name"/>
				</xsl:for-each>
			</xsl:if>
			<!-- 
**************************************************************************************
*                                                                                                         *
*      4. Process all title elements.                                                         *
*                                                                                                         *
************************************************************************************** -->
			<xsl:if test="mods:titleInfo">
				<xsl:comment>
	
*******************************************************
  titles
*******************************************************
</xsl:comment>
				<!-- -->
				<xsl:for-each select="mods:titleInfo">
					<!--
Process uniform and principal  titles (those with no type). Others - abbreviated, etc. - will be treated as variants.
-->
					<xsl:choose>
						<xsl:when test="@type='uniform'">
							<xsl:call-template name="uniformTitle"/>
						</xsl:when>
						<xsl:when test="not(@mods:type) and (not(@type) or (count(@type)=1 and @type='simple'))">
							<!-- ie. no type attribute.  The above idiocy is to account for the stupid XLink simple type -->
						<xsl:call-template name="principalTitle"/> 
						</xsl:when>
					</xsl:choose>
				</xsl:for-each>
			</xsl:if>
			<!-- 
**************************************************************************************
*                                                                                                         *
*      5. Process  identifiers (all except type="modsIdentifier")                   *
*                                                                                                         *
**************************************************************************************
	-->
			<xsl:if test="mods:identifier[not(@type) or @type!='modsIdentifier']">
				<xsl:comment>

***************************
identifier(s)
***************************
</xsl:comment>
				<xsl:for-each select="mods:identifier">
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
			<xsl:if test="mods:subject">
				<xsl:comment>

***************************
subject(s)
***************************
</xsl:comment>
				<xsl:for-each select="mods:subject">
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
			<xsl:if test="mods:genre">
				<xsl:comment>

***************************
genre(s)
***************************
</xsl:comment>
				<xsl:for-each select="mods:genre">
					<xsl:call-template name="genre"/>
					<xsl:value-of select="$newline"/>
				</xsl:for-each>
			</xsl:if>
			<!-- 
**************************************************************************************
*                                                                                                         *
*      8. Process  simple elements:                                                        *
*  abstract, accessCondition, tableOfContents, targetAudience                 *
*                                                                                                         *
**************************************************************************************
	-->
			<xsl:if test="
    	mods:abstract
or 	mods:accessCondition
or 	mods:tableOfContents
or 	mods:targetAudience">
				<xsl:value-of select="$newline"/>
				<xsl:comment>
	
*************************
simple elements 
*************************
</xsl:comment>
				<xsl:value-of select="$newline"/>
				<!-- -->
				<xsl:for-each select="mods:abstract | mods:accessCondition | mods:tableOfContents | mods:targetAudience">
					<xsl:call-template name="simpleElement">
						<xsl:with-param name="elementName" select="local-name()"/>
						<xsl:with-param name="elementValue" select="."/>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:if>
			<!-- 
**************************************************************************************
*                                                                                                         *
*      9. Process  remaining elements except recordInfo  and relatedItem   *
*                                                                                                         *
**************************************************************************************
	-->
			<xsl:if test="
    	mods:classification
or 	mods:language
or 	mods:location
or 	mods:originInfo
or 	mods:note
or 	mods:part
or 	mods:physicalDescription">
				<xsl:value-of select="$newline"/>
				<xsl:comment>
	
*************************
other elements 
*************************
</xsl:comment>
				<xsl:value-of select="$newline"/>
				<!-- -->
				<!-- -->
				<xsl:for-each select="mods:classification">
					<xsl:call-template name="classification"/>
				</xsl:for-each>
				<!-- -->
				<xsl:for-each select="mods:language">
					<xsl:call-template name="language"/>
				</xsl:for-each>
				<!-- -->
				<xsl:for-each select="mods:location">
					<xsl:call-template name="location"/>
				</xsl:for-each>
				<!-- -->
				<xsl:for-each select="mods:originInfo">
					<xsl:call-template name="originInfo"/>
				</xsl:for-each>
				<!-- -->
				<xsl:for-each select="mods:note">
					<xsl:call-template name="note"/>
				</xsl:for-each>
				<!-- -->
				<xsl:for-each select="mods:part">
					<xsl:call-template name="part"/>
				</xsl:for-each>
				<!-- -->
				<xsl:for-each select="mods:physicalDescription">
					<xsl:call-template name="physicalDescription"/>
				</xsl:for-each>
				<!-- -->
			</xsl:if>
			<!--   -->
			<!-- 
****************************************************************
*                                                                              *
*      9.   Process administrative metadata (recordInfo) *
*                                                                              *
****************************************************************
	-->
			<xsl:if test="mods:recordInfo">
				<xsl:value-of select="$newline"/>
				<xsl:comment>
					
********************************  administrative metadata follows  *****************************************		
		
				</xsl:comment>
				<xsl:value-of select="$newline"/>
				<xsl:for-each select="mods:recordInfo">
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
			<xsl:if test="mods:relatedItem">
				<xsl:value-of select="$newline"/>
				<xsl:comment>
					
				
********************************  relatedItems follow *****************************************				
				</xsl:comment>
				<xsl:for-each select="mods:relatedItem">
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
	</xsl:template>
	<!--
	*******************************************************************************************************
	
	Templates for each of the MODS (non-simple) top level elements follow, alphabetically.
	
		******************************************************************************************************* -->
	<!--		
********************Template for MODS classification element:
If the classification scheme (authority attribute) belongs to the list (see top), the scheme is used for the property, prefixed by "class:", for example, "class:lcc".  If not, use classificationGroup to group the classification with its scheme -->
	<xsl:template name="classification">
		<xsl:comment>
		
*******classification
</xsl:comment>
		<xsl:variable name="scheme">
			<xsl:choose>
				<xsl:when test="@authority">
					<xsl:value-of select="@authority"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'class'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!-- -->
		<xsl:value-of select="$newline"/>
		<xsl:choose>
			<xsl:when test="exists($classificationSchemeList[. = $scheme])">
				<xsl:element name="{concat('class:', $scheme,@edition)}">
					<xsl:value-of select="."/>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<modsrdf:classificationGroup>
					<ClassificationGroup>
						<classificationGroupScheme>
							<xsl:value-of select="$scheme"/>
						</classificationGroupScheme>
						<classificationGroupValue>
							<xsl:value-of select="."/>
						</classificationGroupValue>
					</ClassificationGroup>
				</modsrdf:classificationGroup>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:value-of select="$newline"/>
	</xsl:template>
	<!--		
********************Template for MODS genre element 
		-->
	<xsl:template name="genre">
		<xsl:comment>
		
*******genre
</xsl:comment>
		<modsrdf:genre>
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
		</modsrdf:genre>
		<xsl:value-of select="$newline"/>
	</xsl:template>
	<!--		
********************Template for MODS identifer element.  (Other than type="modsIdentifier".)

 If there is a type, and f it belongs to the list (see top), that type is used for the relation, prefixed by "identifier", for example, "identifier:isbn". If not, use identifierGroup to group the identifier with its type
-->
	<xsl:template name="identifier">
		<xsl:variable name="type">
			<xsl:choose>
				<xsl:when test="@type">
					<xsl:value-of select="@type"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'identifier'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!-- -->
		<xsl:value-of select="$newline"/>
		<xsl:choose>
			<xsl:when test="exists($identifierList[. = $type])">
				<xsl:element name="{concat('identifier:', $type)}">
					<xsl:value-of select="."/>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<modsrdf:identifierGroup>
					<IdentifierGroup>
						<identifierGroupType>
							<xsl:value-of select="$type"/>
						</identifierGroupType>
						<identifierGroupValue>
							<xsl:value-of select="."/>
						</identifierGroupValue>
					</IdentifierGroup>
				</modsrdf:identifierGroup>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:value-of select="$newline"/>
	</xsl:template>
	<!--		
********************Template for MODS language element:  
If type="code" a URI is generated; if not, text. 
		-->
	<xsl:template name="language">
		<xsl:comment>
		
*******language
</xsl:comment>
		<xsl:value-of select="$newline"/>
		<xsl:for-each select="mods:languageTerm">
			<xsl:element name="LanguageOfResource" namespace="http://www.loc.gov/mods/rdf/v1#">
				<xsl:choose>
					<xsl:when test="@type='code' or @authority">
						<xsl:attribute name="rdf:resource" select="concat('http://id.loc.gov/vocabulary/language#',.)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="."/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:element>
			<xsl:value-of select="$newline"/>
		</xsl:for-each>
	</xsl:template>
	<!--		
********************Template for MODS location element:  
		-->
	<xsl:template name="location">
		<xsl:comment>
		
***************location
</xsl:comment>
		<xsl:element name="locationOfResource" namespace="http://www.loc.gov/mods/rdf/v1#">
			<xsl:element name="Location" namespace="http://www.loc.gov/mods/rdf/v1#">
				<!-- -->
				<xsl:for-each select="mods:physicalLocation">
					<xsl:element name="locationPhysicalLocation" namespace="http://www.loc.gov/mods/rdf/v1#">
						<xsl:value-of select="."/>
					</xsl:element>
				</xsl:for-each>
				<!-- -->
				<xsl:for-each select="mods:shelfLocator">
					<xsl:element name="locationShelfLocator" namespace="http://www.loc.gov/mods/rdf/v1#">
						<xsl:value-of select="."/>
					</xsl:element>
				</xsl:for-each>
				<!-- -->
				<xsl:for-each select="mods:url">
					<xsl:element name="locationUrl" namespace="http://www.loc.gov/mods/rdf/v1#">
						<xsl:value-of select="."/>
					</xsl:element>
				</xsl:for-each>
				<!-- -->
				<xsl:if test="mods:holdingSimple">
					<xsl:for-each select="mods:holdingSimple/mods:copyInformation">
						<xsl:element name="locationCopy" namespace="http://www.loc.gov/mods/rdf/v1#">
							<xsl:element name="Copy" namespace="http://www.loc.gov/mods/rdf/v1#">
								<!-- -->
								<xsl:if test="mods:form">
									<xsl:element name="locationCopyForm" namespace="http://www.loc.gov/mods/rdf/v1#">
										<xsl:value-of select="mods:form"/>
									</xsl:element>
								</xsl:if>
								<!-- -->
								<xsl:for-each select="mods:subLocation">
									<xsl:element name="locationCopySubLocation" namespace="http://www.loc.gov/mods/rdf/v1#">
										<xsl:value-of select="."/>
									</xsl:element>
								</xsl:for-each>
								<!-- -->
								<xsl:for-each select="mods:shelfLocator">
									<xsl:element name="locationCopyShelfLocator" namespace="http://www.loc.gov/mods/rdf/v1#">
										<xsl:value-of select="."/>
									</xsl:element>
								</xsl:for-each>
								<!-- -->
								<xsl:for-each select="mods:electronicLocator">
									<xsl:element name="locationCopyElectronicLocator" namespace="http://www.loc.gov/mods/rdf/v1#">
										<xsl:value-of select="."/>
									</xsl:element>
								</xsl:for-each>
								<!-- -->
								<xsl:for-each select="mods:note">
									<xsl:element name="locationCopyNote" namespace="http://www.loc.gov/mods/rdf/v1#">
										<xsl:value-of select="."/>
									</xsl:element>
								</xsl:for-each>
								<!-- -->
								<xsl:for-each select="mods:enumerationAndChronology">
									<xsl:variable name="enumChronElementName">
										<xsl:choose>
											<xsl:when test="@unitType='1'">
												<xsl:text>locationCopyEnumerationAndChronologyBasic</xsl:text>
											</xsl:when>
											<xsl:when test="@unitType='2'">
												<xsl:text>locationCopyEnumerationAndChronologySupplement</xsl:text>
											</xsl:when>
											<xsl:when test="@unitType='3'">
												<xsl:text>locationCopyEnumerationAndChronologyIndex</xsl:text>
											</xsl:when>
											<xsl:otherwise>
												<xsl:text>locationCopyEnumerationAndChronology</xsl:text>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:variable>
									<xsl:element name="{$enumChronElementName}" namespace="http://www.loc.gov/mods/rdf/v1#">
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
	<xsl:template name="name">
		<xsl:for-each select=".">
			<!-- -->
			<xsl:variable name="thisIsThePrincipalName">
				<xsl:choose>
					<xsl:when test="
					      @usage 
					         or (
    			                (mods:role[mods:roleTerm='creator'] or mods:role[mods:roleTerm='cre'] )
				                and count(
				                           /mods:mods/mods:name/mods:role[mods:roleTerm='creator'] 				                           
                                               or			                                                                                                
				                           /mods:mods/mods:name/mods:role[mods:roleTerm='cre'] 				                           
				                           )=1 
				                and not(/mods:mods/mods:name/@usage)
				                )">
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
			<xsl:variable name="nameOrNamePrincipal">
				<xsl:choose>
					<xsl:when test="$thisIsThePrincipalName='yes'">
						<xsl:text>namePrincipal</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>name</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<!-- -->
			<xsl:comment>
			** Name **			
			</xsl:comment>
			<xsl:value-of select="$newline"/>
			<xsl:element name="{$nameOrNamePrincipal}" namespace="http://www.loc.gov/mods/rdf/v1#">
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

   - if it is in the relators list (see top), create a property via URI for that role, e.g. relator:cre (where relator is the prefix for http://id.loc.gov/vocabulary/relator/ identifying the LC vocabulary of relators)  where the object of the property is the name.

 - if there is no authority, create a blank node, RoleRelationship, with two properties: (1) role, and (2) name.
-->
			<xsl:for-each select="mods:role">
				<xsl:for-each select="mods:roleTerm">
					<xsl:variable name="role" select="."/>
					<xsl:choose>
						<xsl:when test="exists($relatorsList[. = $role])">
							<xsl:element name="{concat('relator:', $role)}">
								<xsl:attribute name="rdf:resource" select="$nameIdentifier"/>
							</xsl:element>
						</xsl:when>
						<xsl:otherwise>
							<modsrdf:roleRelationship>
								<modsrdf:RoleRelationship>
									<modsrdf:roleRelationshipRole>
										<xsl:value-of select="."/>
									</modsrdf:roleRelationshipRole>
									<xsl:element name="modsrdf:roleRelationshipName">
										<xsl:attribute name="rdf:resource" select="$nameIdentifier"/>
									</xsl:element>
								</modsrdf:RoleRelationship>
							</modsrdf:roleRelationship>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
				<xsl:value-of select="$newline"/>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:template>
	<!--		
******************** Sub Template for name string.  

		-->
	<xsl:template name="nameString">
		<xsl:choose>
			<xsl:when test="mods:displayForm">
				<xsl:value-of select="mods:displayForm"/>
			</xsl:when>
			<xsl:when test="mods:namePart[not(@type)]">
				<xsl:value-of select="	mods:namePart[not(@type)]"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat(
					mods:namePart[@type='termsOfAddress'],
					$space,
					mods:namePart[@type='given'],
					$space,
					mods:namePart[@type='family'],
					$space,
					mods:namePart[@type='date'],
					$space)"/>
			</xsl:otherwise>
		</xsl:choose>
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
				<xsl:if test=".!='simple'">
					<!-- avoid the stupid XLink simple attribute -->
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
						<xsl:call-template name="nameString"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:element>
			<!-- -->
			<xsl:if test="mods:namePart">
						<!-- This condition added 6/7/2013.  To account for the possibility that an authority link was supplied but no parsed name.  However, a display name should be provided, or this won't work so well.
-->
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
							<!-- -->
				</xsl:if> 			
							<!-- -->
						<xsl:value-of select="$newline"/>
						<xsl:if test="@xlink:href">
					<xsl:element name="authorityLink" namespace="http://www.loc.gov/mods/rdf/v1#">
					<xsl:attribute name="rdf:resource">
<xsl:value-of select="@xlink:href"/>					
					</xsl:attribute>
					</xsl:element>
	<xsl:value-of select="$newline"/>
					</xsl:if>
		</xsl:element>

	</xsl:template>
	<!--		
********************Template for MODS note element:  
If type is "statement of responsibility" then generate the property 'statementOfResponsibility'. Otherwise, generate 'hasNote' and create blank node when there is a type.
		-->
	<xsl:template name="note">
		<xsl:choose>
			<xsl:when test="@type='statement of responsibility'">
				<!-- 
statement of responsibility
-->
				<xsl:comment>
		
*******statement of responsibility
</xsl:comment>
				<xsl:value-of select="$newline"/>
				<modsrdf:statementOfResponsibility>
					<xsl:value-of select="."/>
				</modsrdf:statementOfResponsibility>
			</xsl:when>
			<!-- -->
			<xsl:when test="count(@type)=1 and count(@mods:type)=0">
				<!-- ie. no type attribute, count =1 to account for the stupid XLink simple type -->
				<!-- 
Note  - no type
-->
				<xsl:comment>
		
*******note - no type
</xsl:comment>
				<xsl:value-of select="$newline"/>
				<modsrdf:note>
					<xsl:value-of select="."/>
				</modsrdf:note>
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
				<modsrdf:noteGroup>
					<modsrdf:NoteGroup>
						<modsrdf:noteGroupType>
							<!-- -->
							<xsl:variable name="Type">
								<xsl:for-each select="@type">
									<xsl:if test=".!='simple'">
										<!--									 avoid the stupid XLink simple attribute  -->
										<xsl:value-of select="."/>
									</xsl:if>
								</xsl:for-each>
							</xsl:variable>
							<!-- -->
							<xsl:value-of select="$Type"/>
						</modsrdf:noteGroupType>
						<modsrdf:noteGroupValue>
							<xsl:value-of select="."/>
						</modsrdf:noteGroupValue>
					</modsrdf:NoteGroup>
				</modsrdf:noteGroup>
				<xsl:value-of select="$newline"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:value-of select="$newline"/>
	</xsl:template>
	<!--		

********************Template for MODS originInfo elements:  
		-->
	<xsl:template name="originInfo">
		<xsl:value-of select="$newline"/>
		<xsl:for-each select="./*">
			<xsl:choose>
				<xsl:when test="local-name()='place'">
					<xsl:for-each select="mods:placeTerm">
						<!--  
                                     place
                                              -->
						<xsl:comment>
		
*******place of origin
</xsl:comment>
						<xsl:value-of select="$newline"/>
						<xsl:element name="placeOfOrigin" namespace="http://www.loc.gov/mods/rdf/v1#">
							<xsl:element name="Geographic" namespace="http://www.loc.gov/mads/rdf/v1#">
								<xsl:element name="label" namespace="http://www.w3.org/2000/01/rdf-schema#">
									<xsl:value-of select="."/>
								</xsl:element>
								<xsl:element name="elementList" namespace="http://www.loc.gov/mads/rdf/v1#">
									<xsl:attribute name="rdf:parseType">Collection</xsl:attribute>
									<xsl:element name="GeographicElement" namespace="http://www.loc.gov/mads/rdf/v1#">
										<xsl:element name="elementValue" namespace="http://www.loc.gov/mads/rdf/v1#">
											<xsl:value-of select="."/>
										</xsl:element>
									</xsl:element>
								</xsl:element>
							</xsl:element>
						</xsl:element>
					</xsl:for-each>
				</xsl:when>
				<xsl:when test="local-name()='publisher'">
					<!--  
                                     publisher
                                              -->
					<xsl:comment>
		
*******  publisher
</xsl:comment>
					<xsl:value-of select="$newline"/>
					<xsl:element name="publisher" namespace="http://www.loc.gov/mods/rdf/v1#">
						<xsl:element name="CorporateName" namespace="http://www.loc.gov/mads/rdf/v1#">
							<xsl:element name="label" namespace="http://www.w3.org/2000/01/rdf-schema#">
								<xsl:value-of select="."/>
							</xsl:element>
							<xsl:element name="elementList" namespace="http://www.loc.gov/mads/rdf/v1#">
								<xsl:attribute name="rdf:parseType">Collection</xsl:attribute>
								<xsl:element name="FullNameElement" namespace="http://www.loc.gov/mads/rdf/v1#">
									<xsl:element name="elementValue" namespace="http://www.loc.gov/mads/rdf/v1#">
										<xsl:value-of select="."/>
									</xsl:element>
								</xsl:element>
							</xsl:element>
						</xsl:element>
					</xsl:element>
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
						<xsl:with-param name="elementPrefix">resource</xsl:with-param>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<!--
                            other 
                                       -->
					<xsl:call-template name="simpleElement">
						<xsl:with-param name="elementName" select="local-name()"/>
						<xsl:with-param name="elementValue" select="."/>
					</xsl:call-template>
					<!-- -->
				</xsl:otherwise>
			</xsl:choose>
			<xsl:value-of select="$newline"/>
		</xsl:for-each>
		<xsl:value-of select="$newline"/>
	</xsl:template>
	<!--   
********************Template for MODS part 
-->
	<xsl:template name="part">
		<xsl:comment>
		
*******part
</xsl:comment>
		<xsl:value-of select="$newline"/>
		<xsl:element name="part" namespace="http://www.loc.gov/mods/rdf/v1#">
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
					<xsl:element name="partOrder" namespace="http://www.loc.gov/mods/rdf/v1#">
						<xsl:value-of select="@order"/>
					</xsl:element>
					<xsl:value-of select="$newline"/>
				</xsl:if>
				<!-- Part - level -->
				<xsl:if test="mods:detail/@level">
					<xsl:element name="partLevel" namespace="http://www.loc.gov/mods/rdf/v1#">
						<xsl:value-of select="mods:detail/@level"/>
					</xsl:element>
					<xsl:value-of select="$newline"/>
				</xsl:if>
				<!-- Part - extent/@unit -->
				<xsl:if test="mods:extent/@unit">
					<xsl:element name="partUnit" namespace="http://www.loc.gov/mods/rdf/v1#">
						<xsl:value-of select="mods:extent/@unit"/>
					</xsl:element>
					<xsl:value-of select="$newline"/>
				</xsl:if>
				<!-- Part - detailType -->
				<xsl:if test="mods:detail/@type">
					<xsl:element name="partDetailType" namespace="http://www.loc.gov/mods/rdf/v1#">
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
								<xsl:with-param name="elementPrefix">part</xsl:with-param>
							</xsl:call-template>
							<xsl:value-of select="$newline"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:variable name="localName" select="local-name()"/>
							<xsl:element name="{concat('part', upper-case( substring($localName , 1 , 1) ) , substring($localName, 2 ) )}" namespace="http://www.loc.gov/mods/rdf/v1#">
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
	<xsl:template name="physicalDescription">
		<!-- -->
		<xsl:for-each select="./*">
			<xsl:variable name="localName" select="local-name()"/>
			<xsl:variable name="outputName">
				<xsl:choose>
					<xsl:when test="$localName='form'">physicalForm</xsl:when>
					<xsl:when test="$localName='internetMediaType'">mediaType</xsl:when>
					<xsl:when test="$localName='extent'">physicalExtent</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$localName"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:value-of select="$newline"/>
			<xsl:choose>
				<xsl:when test="$outputName = 'note'">
					<xsl:comment>
		
******* note - Physical Description

</xsl:comment>
					<modsrdf:noteGroup>
						<modsrdf:NoteGroup>
							<modsrdf:noteGroupType>
								<xsl:text>Physical Description</xsl:text>
							</modsrdf:noteGroupType>
							<modsrdf:noteGroupValue>
								<xsl:value-of select="."/>
							</modsrdf:noteGroupValue>
						</modsrdf:NoteGroup>
					</modsrdf:noteGroup>
					<xsl:value-of select="$newline"/>
				</xsl:when>
				<!-- -->
				<xsl:otherwise>
					<xsl:call-template name="simpleElement">
						<xsl:with-param name="elementName" select="$outputName"/>
						<xsl:with-param name="elementValue" select="."/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
		<xsl:value-of select="$newline"/>
	</xsl:template>
	<!--   
********************Template for MODS recordInfo, for administrative metadata
-->
	<xsl:template name="recordInfo">
		<!-- -->
		<xsl:element name="administrativeMedatata" namespace="http://www.loc.gov/mods/rdf/v1#">
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
								<xsl:with-param name="elementPrefix">recordInfo</xsl:with-param>
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
				<xsl:if test=".!='simple'">
					<!-- avoid the stupid XLink simple attribute -->
					<xsl:choose>
						<xsl:when test=".='otherVersion'">
							<xsl:text>Version</xsl:text>
						</xsl:when>
						<xsl:when test=".='otherFormat'">
							<xsl:text>Format</xsl:text>
						</xsl:when>
						<xsl:when test=".='isReferencedBy'">
							<xsl:text>Referencer</xsl:text>
						</xsl:when>
						<xsl:when test=".='references'">
							<xsl:text>Reference</xsl:text>
						</xsl:when>
						<xsl:when test=".='reviewOf'">
							<xsl:text>Rreview</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="concat( upper-case( substring(. , 1 , 1) ) , substring(., 2 ) )"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<!-- -->
		<!-- -->
		<xsl:element name="{concat('related', $Type)}">
			<xsl:value-of select="$newline"/>
			<xsl:call-template name="modsRecordOrRelatedItem"/>
			<xsl:value-of select="$newline"/>
		</xsl:element>
		<xsl:value-of select="$newline"/>
	</xsl:template>
	<!--
*******************************************************************************************
Templates for MODS subject follow
******************************************************************************************
-->
	<xsl:template name="subject">
		<!-- 
This is the main template for MODS subject, distinguishing four cases:
1. <subject><cartographics>
this is not treated as a subject. 
2. <subject><hierarchicalGeographic>
this is a special case of a complex subject
3. simple subject: <subject> has one subelement, and that subelement is flat.
4. complex subject: <subject> has multiple subelements  

-->
		<xsl:variable name="subjectType">
			<xsl:choose>
				<xsl:when test="count(./child::node())=1">
					<xsl:value-of select="local-name(./child::node())"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>Complex</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<!--  
case 1  cartographics -->
			<xsl:when test="$subjectType='cartographics'">
				<xsl:call-template name="cartographics"/>
			</xsl:when>
			<!--  
case 2  hierarchicalGeographic-->
			<xsl:when test="$subjectType='hierarchicalGeographic'">
				<xsl:call-template name="hierarchicalGeographic"/>
			</xsl:when>
			<!--  
case 3  simple subject-->
			<xsl:when test="count(./child::node())=1">
				<xsl:comment>
					<xsl:value-of select="$newline"/>
					<xsl:value-of select="concat(' ******* subject: ', $subjectType)"/>
					<xsl:value-of select="$newline"/>
				</xsl:comment>
				<xsl:variable name="subjectSuffix">
					<xsl:choose>
						<xsl:when test="$subjectType='titleInfo'">
							<xsl:text>Title</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="concat(upper-case(substring( $subjectType, 1, 1) ), substring( $subjectType , 2 ) )"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:element name="{concat('subject',$subjectSuffix)}" namespace="http://www.loc.gov/mods/rdf/v1#">
					<xsl:call-template name="simpleSubject">
						<xsl:with-param name="subjectType" select="$subjectType"/>
					</xsl:call-template>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<!--  
case 4  complex subject-->
				<xsl:call-template name="complexSubject"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- -->
	<xsl:template name="simpleSubject">
		<xsl:param name="subjectType"/>
		<!-- -->
		<xsl:variable name="subj">
			<xsl:choose>
				<xsl:when test="$subjectType='titleInfo'">
					<xsl:text>title</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$subjectType"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!-- -->
		<xsl:variable name="Subj">
			<xsl:choose>
				<xsl:when test="$subjectType='genre'">
					<xsl:text>GenreForm</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat(upper-case(substring( $subj , 1, 1) ), substring( $subj , 2 ) )"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!-- -->
		<xsl:choose>
			<!--

for subject:  temporal, occupation, genre, or geographic
-->
			<xsl:when test="$subjectType='topic' or $subjectType='temporal' or $subjectType='occupation'  or $subjectType='genre'  or $subjectType='geographic'">
				<xsl:call-template name="simpleSimpleSubject">
					<xsl:with-param name="subjectType" select="$subjectType"/>
					<xsl:with-param name="SubjectType" select="$Subj"/>
					<xsl:with-param name="value" select="./*"/>
				</xsl:call-template>
			</xsl:when>
			<!--

for Subject: titleInfo
-->
			<xsl:when test="$subjectType='titleInfo'">
				<xsl:for-each select="mods:titleInfo">
					<subjectTitle xmlns="http://www.loc.gov/mods/rdf/v1#">
						<Title xmlns="http://www.loc.gov/mads/rdf/v1#">
							<xsl:call-template name="titleMainSubTemplate"/>
						</Title>
					</subjectTitle>
					<xsl:value-of select="$newline"/>
				</xsl:for-each>
			</xsl:when>
			<!--

for Subject: name
-->
			<xsl:when test="$subjectType='name'">
				<xsl:for-each select="mods:name">
					<subjectName xmlns="http://www.loc.gov/mods/rdf/v1#">
						<xsl:call-template name="nameElement">
							<xsl:with-param name="isThisOnePrincipal" select="no"/>
							<xsl:with-param name="about" select="no"/>
							<xsl:with-param name="nameId" select="none"/>
						</xsl:call-template>
					</subjectName>
					<xsl:value-of select="$newline"/>
				</xsl:for-each>
			</xsl:when>
			<!--

for Subject: geographicCode
-->
			<xsl:when test="$subjectType='geographicCode'">
				<subjectGeographicCode xmlns="http://www.loc.gov/mods/rdf/v1#">
					<Geographic xmlns="http://www.loc.gov/mads/rdf/v1#">
						<xsl:variable name="uri" select="concat('http://id.loc.gov/vocabulary/gac/',mods:geographicCode)"/>
						<rdfs:label>
							<xsl:value-of select="$uri"/>
						</rdfs:label>
						<elementList rdf:parseType="Collection">
							<geographicElement>
								<elementValue>
									<xsl:value-of select="$uri"/>
								</elementValue>
							</geographicElement>
						</elementList>
					</Geographic>
				</subjectGeographicCode>
				<xsl:value-of select="$newline"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!--   
******************** simple simple
when there is only a single subelement of subject, and it is flat. 
-->
	<xsl:template name="simpleSimpleSubject">
		<xsl:param name="subjectType"/>
		<xsl:param name="SubjectType"/>
		<xsl:param name="value"/>
		<!-- -->
		<xsl:variable name="subt">
			<xsl:choose>
				<xsl:when test="$SubjectType='GenreForm'">
					<xsl:text>Genre</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$SubjectType"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="$newline"/>
		<xsl:element name="{$SubjectType}" namespace="http://www.loc.gov/mads/rdf/v1#">
			<xsl:value-of select="$newline"/>
			<xsl:element name="label" namespace="http://www.w3.org/2000/01/rdf-schema#">
				<xsl:value-of select="$value"/>
			</xsl:element>
			<xsl:value-of select="$newline"/>
			<xsl:element name="elementList" namespace="http://www.loc.gov/mads/rdf/v1#">
				<xsl:attribute name="rdf:parseType">Collection</xsl:attribute>
				<xsl:element name="{concat($SubjectType,'Element')}" namespace="http://www.loc.gov/mads/rdf/v1#">
					<xsl:element name="elementValue" namespace="http://www.loc.gov/mads/rdf/v1#">
						<xsl:value-of select="$value"/>
					</xsl:element>
				</xsl:element>
			</xsl:element>
			<xsl:value-of select="$newline"/>
			<xsl:value-of select="$newline"/>
		</xsl:element>
	</xsl:template>
	<!-- -->
	<xsl:template name="complexSubject">
		<subjectComplex xmlns="http://www.loc.gov/mods/rdf/v1#">
			<xsl:value-of select="$newline"/>
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
						<xsl:variable name="subjectType" select="local-name()"/>
						<xsl:choose>
							<xsl:when test="$subjectType='topic' or $subjectType='temporal' or $subjectType='occupation'  or $subjectType='genre'  or $subjectType='geographic'">
								<xsl:variable name="SubjectType" select="concat(upper-case(substring( $subjectType , 1, 1) ), substring( $subjectType , 2 ) )"/>
								<xsl:call-template name="simpleSimpleSubject">
									<xsl:with-param name="subjectType" select="$subjectType"/>
									<xsl:with-param name="SubjectType" select="$SubjectType"/>
									<xsl:with-param name="value" select="."/>
								</xsl:call-template>
							</xsl:when>
						</xsl:choose>
					</xsl:for-each>
					<xsl:value-of select="$newline"/>
				</componentList>
				<xsl:value-of select="$newline"/>
			</ComplexSubject>
			<xsl:value-of select="$newline"/>
		</subjectComplex>
	</xsl:template>
	<!-- -->
	<xsl:template name="hierarchicalGeographic"/>
	<!--
****************************************
End Templates for MODS subject 
****************************************
-->
	<!--

                   Template for cartographics 
-->
	<xsl:template name="cartographics">
		<xsl:comment>
			<xsl:value-of select="$newline"/>
			 ******* Cartographics
			<xsl:value-of select="$newline"/>
		</xsl:comment>
		<cartographics xmlns="http://www.loc.gov/mads/rdf/v1#">
			<Cartographics>
				<xsl:if test="mods:cartographics/mods:scale">
					<scale>
						<xsl:value-of select="mods:cartographics/mods:scale"/>
					</scale>
				</xsl:if>
				<xsl:if test="mods:cartographics/mods:projection">
					<projection>
						<xsl:value-of select="mods:cartographics/mods:projection"/>
					</projection>
				</xsl:if>
				<xsl:for-each select="mods:cartographics/mods:coordinates">
					<coordinates>
						<xsl:value-of select="."/>
					</coordinates>
				</xsl:for-each>
			</Cartographics>
		</cartographics>
	</xsl:template>
	<!-- -->
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
		<modsrdf:titleUniform>
			<xsl:choose>
<!-- test: is there any name with usage attribute, or with a role 'cre' or 'creator' BUT NOT MORE THAN 1.  If so, it is a principal name. -->
				<xsl:when test="(/mods:mods/mods:name/@usage) 
				                      or 
				                      ((/mods:mods/mods:name/mods:role[mods:roleTerm='creator'])
				                      or
				                      (/mods:mods/mods:name/mods:role[mods:roleTerm='cre'])
				                      and
				                      (count(
				                       /mods:mods/mods:name/mods:role[mods:roleTerm='creator']
				                      or
				                      /mods:mods/mods:name/mods:role[mods:roleTerm='cre']) = 1)) 		">
				                      
					<!-- there is a principal name, construct a NameTitle -->
					<xsl:call-template name="nameTitle"/>
				</xsl:when>
				<xsl:otherwise>
					<!-- no principal name, just construct a Title -->
					<xsl:call-template name="titlePreliminarySubTemplate">
					<xsl:with-param name="principal" select="$yes"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</modsrdf:titleUniform>
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
		<xsl:element name="titlePrincipal" namespace="http://www.loc.gov/mods/rdf/v1#">
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
			<!-- if it is primary title (usage="primary") attach primary title identifier 
			<xsl:if test="@usage">
				<xsl:attribute name="rdf:about" select="$primaryTitleIdentifier"/>
			</xsl:if>
			-->
			<xsl:call-template name="titleMainSubTemplate"/>
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
	<xsl:template name="titleMainSubTemplate">
		<xsl:variable name="labelType">
			<xsl:choose>
				<xsl:when test="@type='abbreviated' or @type='translated' or @type='alternative'">
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
			<xsl:call-template name="titleString"/>
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
	<xsl:template name="titleString">
		<xsl:value-of select="mods:nonSort"/>
		<xsl:if test="mods:nonSort">
			<xsl:value-of select="$space"/>
		</xsl:if>
		<xsl:value-of select="mods:title"/>
		<xsl:if test="mods:subTitle">
			<xsl:text>: </xsl:text>
			<xsl:value-of select="mods:subTitle"/>
		</xsl:if>
		<xsl:if test="mods:partNumber">
			<xsl:text> - </xsl:text>
			<xsl:value-of select="mods:partNumber"/>
			<xsl:if test="mods:partName">
				<xsl:text>: </xsl:text>
				<xsl:value-of select="mods:partName"/>
			</xsl:if>
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
		<xsl:element name="{$variantElementName}" namespace="http://www.loc.gov/mads/rdf/v1#">
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
				<xsl:for-each select="../mods:titleInfo">
					<xsl:if test="@type='uniform'">
						<xsl:call-template name="titleString"/>
					</xsl:if>
				</xsl:for-each>
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
							<xsl:value-of select="@mods:type"/>
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
	<xsl:template name="resourceType">
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
*************************************** End of templates for individual MODS  elements ***********

********************Template for simple elements: abstract, accessCondition, tableOfContents, targetAudience
-->
	<xsl:template name="simpleElement">
		<xsl:param name="elementName"/>
		<xsl:param name="elementValue"/>
		<xsl:value-of select="$newline"/>
		<xsl:comment>
			<xsl:value-of select="concat('**********',$elementName)"/>
		</xsl:comment>
		<xsl:value-of select="$newline"/>
		<xsl:element name="{$elementName}" namespace="http://www.loc.gov/mods/rdf/v1#">
			<xsl:value-of select="$elementValue"/>
		</xsl:element>
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
		<xsl:param name="elementPrefix"/>
		<!-- -->
		<xsl:variable name="Point" select="concat(upper-case( substring( $point , 1, 1) )  , substring($point , 2 ) )"/>
		<!-- -->
		<xsl:variable name="middleElementName">
			<xsl:choose>
				<xsl:when test="$elementName='dateOther'">
					<xsl:text>Date</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat(upper-case( substring( $elementName , 1, 1) )  , substring($elementName , 2 ) )"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!-- -->
		<xsl:element name="{concat($elementPrefix, $middleElementName,$Point)}" namespace="{$namespace}">
			<xsl:attribute name="rdf:datatype"><xsl:choose><xsl:when test="$normal='iso8601' or $normal='w3cdtf' or $normal='marc'"><xsl:text>xsd:date</xsl:text></xsl:when><xsl:otherwise><xsl:text>xsd:string</xsl:text></xsl:otherwise></xsl:choose></xsl:attribute>
			<xsl:value-of select="$value"/>
		</xsl:element>
		<!-- -->
	</xsl:template>
	<!-- 
*********************************************************
end templates
*********************************************************
-->
</xsl:stylesheet>
