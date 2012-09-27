<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step
    xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:px="http://www.daisy.org/ns/pipeline/xproc"
    xmlns:torch="http://www.torchtrust.org/pipeline"
    exclude-inline-prefixes="px torch"
    type="torch:zedai-translator" version="1.0">

    <p:input port="source" primary="true" px:media-type="application/z3998-auth+xml"/>
    <p:output port="result" primary="true" px:media-type="application/z3998-auth+xml"/>
    
    <!-- Simple translation with SEB -->
    
    <p:xslt>
        <p:input port="stylesheet">
            <p:inline>
                <xsl:stylesheet version="2.0"
                    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                    xmlns:louis="http://liblouis.org/liblouis"
                    exclude-result-prefixes="louis">
                    <xsl:variable name="table" select="'http://www.liblouis.org/tables/unicode.dis,en-GB-g2.ctb,braille-patterns.cti'"/>
                    <xsl:template match="/*">
                        <xsl:copy>
                            <xsl:sequence select="louis:translate($table, string(.))"/>
                        </xsl:copy>
                    </xsl:template>
                </xsl:stylesheet>
            </p:inline>
        </p:input>
        <p:input port="parameters">
            <p:empty/>
        </p:input>
    </p:xslt>
    
</p:declare-step>
