<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="2.0"
	xmlns:dtb="http://www.daisy.org/z3986/2005/dtbook/"
    xmlns="http://www.daisy.org/z3986/2005/dtbook/"
    exclude-result-prefixes="dtb">

<xsl:output method="xml" indent="yes" />
<!-- the identity template -->

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>


<!--    <xsl:template match="xhtml:line[parent::xhtml:address]">
        <xsl:value-of select="."/>
        <br/>
    </xsl:template>

    <xsl:template match="dtb:poem">
        <poem>
            <xsl:apply-templates select="@*|node()"/>
        </poem>
    </xsl:template>

    <xsl:template match="dtb:linegroup[parent::dtb:poem]">
            <xsl:apply-templates select="@*|node()"/>
    </xsl:template>

    <xsl:template match="dtb:line[parent::dtb:linegroup]">
        <linegroup>
            <line>
                <xsl:apply-templates select="@*|node()"/>
            </line>
        </linegroup>
    </xsl:template>
-->
    <xsl:template match="dtb:br[ancestor::dtb:p[@class='NewStanza' or @class='newstanza']]">
        <xsl:text disable-output-escaping="yes"> ⠜ </xsl:text>
    </xsl:template>

</xsl:stylesheet>