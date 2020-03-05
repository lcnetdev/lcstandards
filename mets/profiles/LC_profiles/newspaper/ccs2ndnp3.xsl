<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
		xmlns:mets="http://www.loc.gov/METS/"
		xmlns:mods="http://www.loc.gov/mods/v3"
		xmlns:xlink="http://www.w3.org/1999/xlink"
		xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"



xpath-default-namespace="http://www.loc.gov/METS/"
>


  <xsl:output method="xml" indent="yes" encoding="UTF-8"/>

  <xsl:template match="/">
    <xsl:apply-templates select="mets"/>
  </xsl:template>


  <xsl:template match="mets">
    <mets:mets xsi:schemaLocation="http://www.loc.gov/METS/ http://www.loc.gov/standards/mets/mets.xsd
http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-2b.xsd">
      <xsl:apply-templates select="structMap[@TYPE='LOGICAL']/div/div/div[@TYPE='ISSUE']" mode="mods"/>
      <xsl:apply-templates select="amdSec" mode="amdSec"/>
      <xsl:apply-templates select="fileSec" mode="fileSec"/>
      <xsl:apply-templates select="structMap[@TYPE='PHYSICAL']" mode="structMap"/>
    </mets:mets>
  </xsl:template>


  <!-- logical (MODS) section -->
  <xsl:template match="structMap[@TYPE='LOGICAL']/div/div/div[@TYPE='ISSUE']" mode="mods">
    <mets:dmdSec ID="DMD">
      <mets:mdWrap MDTYPE="MODS">
	<mets:xmlData>
	  <mods:mods ID="{@DMDID}">
	    <mods:titleInfo>
	      <mods:title><xsl:value-of select="@LABEL"/></mods:title>
	    </mods:titleInfo>
	    <mods:genre>newspaper</mods:genre>
	    <mods:originInfo>
	      <mods:dateCreated encoding="w3cdtf" point="start" keyDate="yes" qualifier="approximate"></mods:dateCreated>
	    </mods:originInfo>
	    <mods:language>
	      <mods:languageTerm type="code" authority="rfc3066"></mods:languageTerm>
	    </mods:language>
	    <xsl:apply-templates select="div[@TYPE='TITLE_SECTION']//div[@TYPE='TEXTBLOCK']"/>

	    <xsl:for-each select="div[@TYPE='CONTENT']/div">

	      <xsl:if test="@TYPE='ARTICLE'">
		<xsl:call-template name="article"/>
	      </xsl:if>

	      <xsl:if test="@TYPE='SECTION'">
		<xsl:call-template name="section"/>
	      </xsl:if>

	      <xsl:if test="@TYPE='WEATHER'">
		<xsl:call-template name="weather"/>
	      </xsl:if>
	    </xsl:for-each>


	  </mods:mods>
	</mets:xmlData>
      </mets:mdWrap>
    </mets:dmdSec>
  </xsl:template>

  <xsl:template match="div[@TYPE='TITLE_SECTION']//div[@TYPE='TEXTBLOCK']">
    <mods:note  ID="{@ID}" type="title area">From title area: [extract text from alto file <xsl:value-of select="fptr/area/@FILEID"/><xsl:text> textblock </xsl:text><xsl:value-of select="fptr/area/@BEGIN"/></mods:note>
  </xsl:template>

  <xsl:template name="article">
    <mods:relatedItem type="constituent" ID="{@DMDID}">
      <mods:titleInfo>
	<mods:title><xsl:value-of select="@LABEL"/></mods:title>
      </mods:titleInfo>
      <mods:genre>article</mods:genre>
      <xsl:apply-templates select="div[@TYPE='BODY']/div/div[@TYPE='PARAGRAPH']" mode="mods"/>
    </mods:relatedItem>
  </xsl:template>

  <xsl:template name="section">
    <mods:relatedItem type="constituent" ID="{@DMDID}">
      <mods:titleInfo>
	<mods:title><xsl:value-of select="@LABEL"/></mods:title>
      </mods:titleInfo>
      <mods:genre>section</mods:genre>
      <xsl:apply-templates select="div[@TYPE='ARTICLE']"/>
      <xsl:apply-templates select="div/div/div[@TYPE='ADVERTISEMENT']"/>
    </mods:relatedItem>
  </xsl:template>


  <xsl:template match="div[@TYPE='ARTICLE']">
    <mods:relatedItem type="constituent" ID="{@DMDID}">
      <mods:titleInfo>
	<mods:title><xsl:value-of select="@LABEL"/></mods:title>
      </mods:titleInfo>
      <mods:genre>article</mods:genre>
      <xsl:apply-templates select="div[@TYPE='BODY']/div/div[@TYPE='PARAGRAPH']" mode="mods"/>
      <xsl:apply-templates select="div[@TYPE='BODY']/div/div[@TYPE='ILLUSTRATION']" mode="mods"/>
    </mods:relatedItem>
  </xsl:template>

  <xsl:template match="div/div/div[@TYPE='ADVERTISEMENT']">
    <mods:relatedItem type="constituent" ID="{@ID}">
      <mods:titleInfo>
	<mods:title><xsl:value-of select="@LABEL"/></mods:title>
      </mods:titleInfo>
      <mods:genre>advertisement</mods:genre>
      <!--
      <xsl:apply-templates select="div[@TYPE='BODY']/div/div[@TYPE='PARAGRAPH']" mode="mods"/>
      <xsl:apply-templates select="div[@TYPE='BODY']/div/div[@TYPE='ILLUSTRATION']" mode="mods"/>
      -->
    </mods:relatedItem>
  </xsl:template>


  <xsl:template name="weather">
    <mods:relatedItem type="constituent" ID="{@DMDID}">
      <mods:titleInfo>
	<mods:title><xsl:value-of select="@LABEL"/></mods:title>
      </mods:titleInfo>
      <mods:genre>weather</mods:genre>
      <xsl:apply-templates select="div[@TYPE='BODY']/div[@TYPE='ILLUSTRATION']" mode="mods"/>
      <xsl:apply-templates select="div[@TYPE='BODY']/div/div[@TYPE='PARAGRAPH']" mode="mods"/>
    </mods:relatedItem>
  </xsl:template>


  <xsl:template match="div[@TYPE='BODY']/div/div[@TYPE='PARAGRAPH']" mode="mods">
    <mods:part ID="{@ID}" type="paragraph" order="{@ORDER}"/>
  </xsl:template>

  <xsl:template match="div[@TYPE='BODY']/div[@TYPE='ILLUSTRATION']" mode="mods">
    <mods:relatedItem type="constituent" ID="{@DMDID}">
      <mods:titleInfo>
	<mods:title><xsl:value-of select="@LABEL"/></mods:title>
      </mods:titleInfo>
      <mods:genre>illustration</mods:genre>
    </mods:relatedItem>
  </xsl:template>


  <!-- administrative (amdSec) -->
    <xsl:template match="amdSec" mode="amdSec">
    <mets:amdSec>
      <xsl:copy-of select="@*"/>
    </mets:amdSec>
  </xsl:template>





  <!-- files (fileSec) section -->
  <xsl:template match="fileSec" mode="fileSec">
    <mets:fileSec>
      <xsl:apply-templates select="fileGrp" mode="fileSec"/>
    </mets:fileSec>
  </xsl:template>


  <xsl:template match="fileGrp" mode="fileSec">
    <mets:fileGrp>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates select="file" mode="fileSec"/>
    </mets:fileGrp>
  </xsl:template>


  <xsl:template match="file" mode="fileSec">
    <mets:file>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates select="FLocat" mode="fileSec"/>
    </mets:file>
  </xsl:template>

  <xsl:template match="FLocat" mode="fileSec">
    <mets:FLocat>
      <xsl:copy-of select="@*"/>
    </mets:FLocat>
  </xsl:template>


  <!-- physical (structMap) section -->
  <xsl:template match="structMap[@TYPE='PHYSICAL']" mode="structMap">
    <mets:structMap>
      <mets:div TYPE="ndnp:issue" DMDID="{/mets/structMap[@TYPE='LOGICAL']/div/div/div[@TYPE='ISSUE']/@DMDID}">
	<xsl:apply-templates select="div/div[@TYPE='PAGE']" mode="structMap"/>
      </mets:div>
    </mets:structMap>
  </xsl:template>

  <xsl:template match="structMap[@TYPE='PHYSICAL']/div/div[@TYPE='PAGE']" mode="structMap">
    <mets:div TYPE="ndnp:page">
      <mets:div TYPE="ndnp:image">
	<xsl:apply-templates select="fptr/par/area" mode="structMapIMG"/>
      </mets:div>
      <mets:div TYPE="ndnp:alto">
	<xsl:apply-templates select="fptr/par/area" mode="structMapALT"/>
      </mets:div>
      <xsl:apply-templates select="/mets/structMap[@TYPE='LOGICAL']//area" mode="structMap">
	<xsl:with-param name="FILEID" select="fptr/par/area[2]/@FILEID"/>
      </xsl:apply-templates>
    </mets:div>
  </xsl:template>


  <xsl:template match="fptr/par/area" mode="structMapIMG">
    <xsl:if test="matches(@FILEID,'^IMG')">
      <mets:fptr FILEID="{@FILEID}"/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="fptr/par/area" mode="structMapALT">
    <xsl:if test="matches(@FILEID,'^ALT')">
      <mets:fptr FILEID="{@FILEID}"/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="/mets/structMap[@TYPE='LOGICAL']//area" mode="structMap">
    <xsl:param name="FILEID"/>
    <xsl:if test="@FILEID = $FILEID">


      <!-- for an issue textblock (mods note) -->
      <xsl:if test="ancestor::div[1]/@TYPE='TEXTBLOCK'">
	<mets:div TYPE="ndnp:pageRegion" DMDID="{ancestor::div[1]/@ID}">
	  <mets:div TYPE="ndnp:alto">
	    <mets:fptr>
	      <mets:area BETYPE="IDREF" FILEID="{@FILEID}" BEGIN="{@BEGIN}"/>
	    </mets:fptr>
	  </mets:div>
	</mets:div>
      </xsl:if>


      <!-- for a section -->
      <xsl:if test="ancestor::div[3]/@TYPE='SECTION' and ancestor::div[2]/@TYPE='HEADING'">
	<mets:div TYPE="ndnp:pageRegion" DMDID="{ancestor::div[3]/@DMDID}">
	  <mets:div TYPE="ndnp:alto">
	    <mets:fptr>
	      <mets:area BETYPE="IDREF" FILEID="{@FILEID}" BEGIN="{@BEGIN}"/>
	    </mets:fptr>
	  </mets:div>
	</mets:div>
      </xsl:if>



      <!-- for the first section-->
      <xsl:if test="ancestor::div[5]/@TYPE='SECTION' and ancestor::div[2]/@TYPE='PARAGRAPH'">
	<mets:div TYPE="ndnp:pageRegion" DMDID="{ancestor::div[5]/@DMDID}">
	  <mets:div TYPE="ndnp:alto">
	    <mets:fptr>
	      <mets:area BETYPE="IDREF" FILEID="{@FILEID}" BEGIN="{@BEGIN}"/>
	    </mets:fptr>
	  </mets:div>
	</mets:div>
      </xsl:if>



      <!-- for article with a heading -->
      <xsl:if test="ancestor::div[3]/@TYPE='ARTICLE' and ancestor::div[2]/@TYPE='HEADING'">
	<mets:div TYPE="ndnp:pageRegion" DMDID="{ancestor::div[3]/@DMDID}">
	  <mets:div TYPE="ndnp:alto">
	    <mets:fptr>
	      <mets:area BETYPE="IDREF" FILEID="{@FILEID}" BEGIN="{@BEGIN}"/>
	    </mets:fptr>
	  </mets:div>
	</mets:div>
      </xsl:if>

      <!-- for a paragraph that is a child of a section (not an article) -->
      <xsl:if test="ancestor::div[4]/@TYPE='SECTION' and ancestor::div[2]/@TYPE='PARAGRAPH'">
	<mets:div TYPE="ndnp:pageRegion" DMDID="{@ID}">
	  <mets:div TYPE="ndnp:alto">
	    <mets:fptr>
	      <mets:area BETYPE="IDREF" FILEID="{@FILEID}" BEGIN="{@BEGIN}"/>
	    </mets:fptr>
	  </mets:div>
	</mets:div>
      </xsl:if>

      <!-- for article without a heading -->
      <xsl:if test="ancestor::div[5]/@TYPE='ARTICLE' and not(ancestor::div[4]/preceding-sibling::div[@TYPE='HEADING'])">
	<mets:div TYPE="ndnp:pageRegion" DMDID="{ancestor::div[5]/@DMDID}">
	  <mets:div TYPE="ndnp:alto">
	    <mets:fptr>
	      <mets:area BETYPE="IDREF" FILEID="{@FILEID}" BEGIN="{@BEGIN}"/>
	    </mets:fptr>
	  </mets:div>
	</mets:div>
      </xsl:if>
      <!-- for an advertisement -->
      <xsl:if test="ancestor::div[1]/@TYPE='ADVERTISEMENT'">
	<mets:div TYPE="ndnp:pageRegion" DMDID="{ancestor::div[1]/@ID}">
	  <mets:div TYPE="ndnp:alto">
	    <mets:fptr>
	      <mets:area BETYPE="IDREF" FILEID="{@FILEID}" BEGIN="{@BEGIN}"/>
	    </mets:fptr>
	  </mets:div>
	</mets:div>
      </xsl:if>
      <!-- for a paragraph -->
      <xsl:if test="ancestor::div[2]/@TYPE='PARAGRAPH'">
	<mets:div TYPE="ndnp:pageRegion" DMDID="{ancestor::div[2]/@ID}">
	  <mets:div TYPE="ndnp:alto">
	    <mets:fptr>
	      <mets:area BETYPE="IDREF" FILEID="{@FILEID}" BEGIN="{@BEGIN}"/>
	    </mets:fptr>
	  </mets:div>
	</mets:div>
      </xsl:if>


    </xsl:if>
  </xsl:template>






</xsl:stylesheet>