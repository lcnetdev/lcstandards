<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:profile="http://www.loc.gov/METS_Profile/" exclude-result-prefixes="profile" >

  <xsl:import href="xmlverbatim.xsl"/>

  <xsl:key match="*[@ID]" use="@ID" name="id"/>

  <xsl:output method="xhtml" indent="yes"/>

  <xsl:template match="/">
    <html>
      <head>
	<title>
	  <xsl:call-template name="profile:title_tag"/>
	</title>
	<link rel="stylesheet" type="text/css" href="../stylesheets/profile.css"/>
      </head>
      <body>
	<h2>LC METS Profile</h2>
	<xsl:apply-templates select="profile:METS_Profile"/>
      </body>
    </html>
  </xsl:template>


  <xsl:template match="profile:METS_Profile">
    <xsl:apply-templates select="profile:title"/>
    <xsl:apply-templates select="profile:URI" mode="profile_uri_xml"/>
    <xsl:apply-templates select="profile:Appendix" mode="example_docs"/>
    <xsl:apply-templates select="profile:abstract"/>
    <xsl:apply-templates select="profile:URI" mode="profile_uri"/>
    <xsl:apply-templates select="profile:date"/>
    <xsl:apply-templates select="profile:contact" mode="display"/>
    <xsl:apply-templates select="profile:related_profile"/>
    <xsl:apply-templates select="profile:extension_schema"/>
    <xsl:apply-templates select="profile:description_rules"/>
    <xsl:apply-templates select="profile:controlled_vocabularies"/>
    <xsl:apply-templates select="profile:structural_requirements"/>
    <xsl:apply-templates select="profile:technical_requirements"/>

    <!--    <xsl:apply-templates select="profile:Appendix"/> -->
  </xsl:template>


  <xsl:template name="profile:title_tag">
    <xsl:value-of select="profile:METS_Profile/profile:title"/>
  </xsl:template>


  <xsl:template match="profile:title">
    <h3>
      <xsl:value-of select="."/>
    </h3>
    <hr/>
  </xsl:template>

  <xsl:template match="profile:abstract">
    <br/>
    <h4>Abstract</h4>
    <p>
      <xsl:value-of select="."/>
    </p>
  </xsl:template>

  <xsl:template match="profile:URI" mode="profile_uri_xml">
    <xsl:param name="url" select="."/>
    <p>
      <a href="{$url}">XML Version of Profile Document</a>
    </p>
    <hr/>
  </xsl:template>

  <xsl:template match="profile:URI" mode="profile_uri">
    <br/>
    <h4>URI</h4>
    <p>
      <xsl:value-of select="."/>
    </p>
  </xsl:template>

  <xsl:template match="profile:date">
    <br/>
    <h4>Date</h4>
    <p>
      <xsl:value-of select="."/>
    </p>
  </xsl:template>


  <xsl:template match="profile:contact" mode="display">
    <h4>Contact</h4>
    <p>
      <xsl:apply-templates select="profile:name" mode="display"/><br/>
      <xsl:apply-templates select="profile:institution" mode="display"/><br/>
      <xsl:apply-templates select="profile:address" mode="display"/>
    </p>
  </xsl:template>


  <xsl:template match="profile:related_profile">
    <br/>
    <h4>Related Profile</h4>
    <p>
      <xsl:value-of select="."/>
    </p>
  </xsl:template>


  <xsl:template match="profile:extension_schema">
    <br/>
    <h4>Extension Schema</h4>
    <p>
      <xsl:apply-templates select="profile:name" mode="schema_name"/><br/>
      <xsl:apply-templates select="profile:URI" mode="schema_uri"/>
    </p>
  </xsl:template>


  <xsl:template match="profile:name" mode="schema_name">
    <xsl:value-of select="."/>
  </xsl:template>

  <xsl:template match="profile:URI" mode="schema_uri">
    <xsl:value-of select="."/>
  </xsl:template>

  <xsl:template match="profile:name" mode="display">
    <b><xsl:value-of select="."/></b>
  </xsl:template>

  <xsl:template match="profile:institution"  mode="display">
    <xsl:value-of select="."/>
  </xsl:template>

  <xsl:template match="profile:address"  mode="display">
    <xsl:value-of select="."/>
  </xsl:template>

  <xsl:template match="profile:description_rules">
    <br/>
    <h4>Description Rules</h4>
    <xsl:apply-templates select="profile:head"/>
    <xsl:apply-templates select="profile:p"/>
  </xsl:template>



  <xsl:template match="profile:controlled_vocabularies">
    <br/>
    <h4>Controlled Vocabularies</h4>
    <xsl:apply-templates select="profile:vocabulary"/>
  </xsl:template>

  <xsl:template match="profile:vocabulary">
    <p>
      <xsl:apply-templates select="profile:name" mode="display"/><br/>
      <xsl:apply-templates select="profile:maintenance_agency"/><br/>
      <xsl:apply-templates select="profile:URI"/><br/>
      <xsl:apply-templates select="profile:context"/>
    </p>
  </xsl:template>

  <xsl:template match="profile:maintenance_agency">
    <xsl:value-of select="."/>
  </xsl:template>

  <xsl:template match="profile:URI">
    <xsl:value-of select="."/>
  </xsl:template>

  <xsl:template match="profile:context">
    <xsl:value-of select="."/>
  </xsl:template>


  <xsl:template match="profile:structural_requirements">
    <h3>Structural Requirements</h3>
    <xsl:apply-templates select="profile:metsRootElement"/>
    <xsl:apply-templates select="profile:metsHdr"/>
    <xsl:apply-templates select="profile:dmdSec"/>
    <xsl:apply-templates select="profile:amdSec"/>
    <xsl:apply-templates select="profile:fileSec"/>
    <xsl:apply-templates select="profile:structMap"/>
    <xsl:apply-templates select="profile:multiSection"/>
  </xsl:template>

  <xsl:template match="profile:metsRootElement">
    <h5>METS Root Element</h5>
    <xsl:apply-templates select="profile:requirement"/>
  </xsl:template>


  <xsl:template match="profile:metsHdr">
    <h5>METS Header Element</h5>
    <xsl:apply-templates select="profile:requirement"/>
  </xsl:template>


  <xsl:template match="profile:dmdSec">
    <h5>Descriptive Metadata Section</h5>
    <xsl:apply-templates select="profile:requirement"/>
  </xsl:template>

  <xsl:template match="profile:amdSec">
    <h5>Administrative Metadata Section</h5>
    <xsl:apply-templates select="profile:requirement"/>
  </xsl:template>

  <xsl:template match="profile:fileSec">
    <h5>File Section</h5>
    <xsl:apply-templates select="profile:requirement"/>
  </xsl:template>

  <xsl:template match="profile:structMap">
    <h5>Structure Map</h5>
    <xsl:apply-templates select="profile:requirement"/>
  </xsl:template>

  <xsl:template match="profile:multiSection">
    <h5>Multiple Sections</h5>
    <xsl:apply-templates select="profile:requirement"/>
  </xsl:template>


  <xsl:template match="profile:requirement">
<!--    <xsl:param name="req_no" select="@profile:RELATEDMAT"/>  -->
    <h6>
    <xsl:value-of select="name(..)"/> Requirement <xsl:value-of select="position()"/></h6>
    <xsl:apply-templates select="profile:p"/>
    <xsl:apply-templates select="key('id',@RELATEDMAT)" mode="tag_examples"/>
    <!--<xsl:apply-templates select="profile:Appendix" mode="tag_examples">
	 <xsl:with-param name="req_no" select="$req_no"/>
	 </xsl:apply-templates>-->
  </xsl:template>


  <xsl:template match="profile:Appendix" mode="tag_examples">
    <!-- <xsl:param name="req_no"/> -->
    <h6>Example <xsl:value-of select="@NUMBER"/>.</h6>
    <div class="box">
      <!-- call verbatim formatter -->
      <xsl:apply-templates select="node()" mode="xmlverb"/>
    </div>
    <br/>
    <br/>
  </xsl:template>


  <xsl:template match="profile:Appendix" mode="example_docs">
    <xsl:apply-templates select="profile:exampleDoc">
      <xsl:with-param name="example_url" select="profile:exampleDoc"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="profile:exampleDoc">
    <xsl:param name="example_url"/>
    <p>
      <a href="{$example_url}">Example Instance Document</a>
    </p>
    <hr/>
  </xsl:template>

  <xsl:template match="profile:head">
    <h5>
      <xsl:value-of select="."/>
    </h5>
  </xsl:template>

  <xsl:template match="profile:p">
    <p>
      <xsl:value-of select="."/>
    </p>
  </xsl:template>


  <xsl:template match="profile:technical_requirements">
    <h3>Technical Requirements</h3>
    <xsl:apply-templates select="profile:content_files"/>
  </xsl:template>

  <xsl:template match="profile:content_files">
    <h4>Content Files</h4>
    <xsl:apply-templates select="profile:requirement" mode="content_files"/>
  </xsl:template>

  <xsl:template match="profile:requirement" mode="content_files">
    <xsl:apply-templates select="profile:head"/>
    <xsl:apply-templates select="profile:p"/>
  </xsl:template>


</xsl:stylesheet>
