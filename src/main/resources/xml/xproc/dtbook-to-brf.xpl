<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step
    xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:px="http://www.daisy.org/ns/pipeline/xproc"
    xmlns:torch="http://www.torchtrust.org/pipeline"
    xmlns:pef="http://www.daisy.org/ns/2008/pef"
    xmlns:d="http://www.daisy.org/ns/pipeline/data"
    exclude-inline-prefixes="px d torch pef"
    type="torch:dtbook-to-brf" name="dtbook-to-brf" version="1.0">

    <p:documentation xmlns="http://www.w3.org/1999/xhtml">
        <h1 px:role="name">DTBook to BRF (Torch Trust)</h1>
        <p px:role="desc">Transforms a DTBook (DAISY 3 XML) document into a BRF, following Torch Trust transcription rules.</p>
        <dl px:role="author">
            <dt>Name:</dt>
            <dd px:role="name">Paul Wood</dd>
            <dt>Organization:</dt>
            <dd px:role="organization" href="http://www.torchtrust.org/">Torch Trust</dd>
            <dt>E-mail:</dt>
            <dd>><a px:role="contact" href="mailto:paulw@torchtrust.org">paulw@torchtrust.org</a></dd>
        </dl>
    </p:documentation>

    <p:input port="source" primary="true" px:name="source" px:media-type="application/x-dtbook+xml">
        <p:documentation>
            <h2 px:role="name">source</h2>
            <p px:role="desc">Input DTBook.</p>
        </p:documentation>
    </p:input>
    
    <p:option name="output-dir" required="true" px:output="result" px:sequence="false" px:type="anyDirURI">
        <p:documentation>
            <h2 px:role="name">output-dir</h2>
            <p px:role="desc">Path to output directory for the BRF.</p>
        </p:documentation>
    </p:option>
    
    <p:option name="temp-dir" required="true" px:output="temp" px:sequence="false" px:type="anyDirURI">
        <p:documentation>
            <h2 px:role="name">temp-dir</h2>
            <p px:role="desc">Path to directory for storing temporary files.</p>
        </p:documentation>
    </p:option>
    
    <p:option name="pef" required="false" px:type="boolean" select="'false'">
        <p:documentation>
            <h2 px:role="name">pef</h2>
            <p px:role="desc">Whether or not to include a PEF too (true or false).</p>
        </p:documentation>
    </p:option>
    
    <p:option name="preview" required="false" px:type="boolean" select="'false'">
        <p:documentation>
            <h2 px:role="name">preview</h2>
            <p px:role="desc">Whether or not to include a preview of the PEF in HTML (true or false).</p>
        </p:documentation>
    </p:option>
    
    <p:import href="http://www.daisy.org/pipeline/modules/dtbook-utils/dtbook-load.xpl"/>
    <p:import href="http://www.daisy.org/pipeline/modules/dtbook-to-zedai/dtbook-to-zedai.convert.xpl"/>
    <p:import href="http://www.daisy.org/pipeline/modules/dtbook-to-zedai/dtbook-to-zedai.store.xpl"/>
    <p:import href="http://www.daisy.org/pipeline/modules/braille/zedai-to-pef/xproc/zedai-to-pef.convert.xpl"/>
    <p:import href="http://www.daisy.org/pipeline/modules/braille/pef-to-html/xproc/pef-to-html.convert.xpl"/>
    <p:import href="http://www.daisy.org/pipeline/modules/braille/pef-calabash/xproc/library.xpl"/>
    
    <p:variable name="stylesheet" select="'http://www.torchtrust.org/pipeline/braille/zedai.css'"/>
    <p:variable name="preprocessor" select="''"/>
    <p:variable name="translator" select="'http://www.torchtrust.org/pipeline/braille/zedai-translator.xpl'"/>
    <p:variable name="table" select="'org.daisy.braille.table.DefaultTableProvider.TableType.EN_US'"/>
    
    <!-- =============== -->
    <!-- DTBOOK TO ZEDAI -->
    <!-- =============== -->
    
    <px:dtbook-load name="load"/>
    <px:dtbook-to-zedai-convert name="zedai">
        <p:input port="in-memory.in">
            <p:pipe step="load" port="in-memory.out"/>
        </p:input>
        <p:with-option name="opt-output-dir" select="$temp-dir"/>
    </px:dtbook-to-zedai-convert>
    <p:sink/>
    
    <!-- ============ -->
    <!-- ZEDAI TO PEF -->
    <!-- ============ -->
    
    <p:split-sequence>
        <p:input port="source">
            <p:pipe step="zedai" port="in-memory.out"/>
        </p:input>
        <p:with-option name="test"
            select="concat('/*/@xml:base=&quot;',
                            //d:file[@media-type='application/z3998-auth+xml'][1]/resolve-uri(@href, base-uri()),
                            '&quot;')">
            <p:pipe step="zedai" port="fileset.out"/>
        </p:with-option>
    </p:split-sequence>
    <px:zedai-to-pef.convert name="pef">
        <p:with-option name="stylesheet" select="$stylesheet"/>
        <p:with-option name="preprocessor" select="$preprocessor"/>
        <p:with-option name="translator" select="$translator"/>
        <p:with-option name="temp-dir" select="$temp-dir"/>
    </px:zedai-to-pef.convert>
    
    <!-- ===== -->
    <!-- STORE -->
    <!-- ===== -->
    
    <p:xslt name="output-dir-uri">
        <p:with-param name="href" select="concat($output-dir,'/')"/>
        <p:input port="source">
            <p:inline>
                <d:file/>
            </p:inline>
        </p:input>
        <p:input port="stylesheet">
            <p:inline>
                <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:pf="http://www.daisy.org/ns/pipeline/functions" version="2.0">
                    <xsl:import href="http://www.daisy.org/pipeline/modules/file-utils/xslt/uri-functions.xsl"/>
                    <xsl:param name="href" required="yes"/>
                    <xsl:template match="/*">
                        <xsl:copy>
                            <xsl:attribute name="href" select="pf:normalize-uri($href)"/>
                        </xsl:copy>
                    </xsl:template>
                </xsl:stylesheet>
            </p:inline>
        </p:input>
    </p:xslt>
    <p:sink/>
    
    <p:group>
        <p:variable name="output-dir-uri" select="/*/@href">
            <p:pipe step="output-dir-uri" port="result"/>
        </p:variable>
        
        <!-- ============== -->
        <!-- STORE AS ZEDAI -->
        <!-- ============== -->
        
        <px:dtbook-to-zedai-store>
            <p:input port="fileset.in">
                <p:pipe step="zedai" port="fileset.out"/>
            </p:input>
            <p:input port="in-memory.in">
                <p:pipe step="zedai" port="in-memory.out"/>
            </p:input>
        </px:dtbook-to-zedai-store>
        
        <!-- ============ -->
        <!-- STORE AS BRF -->
        <!-- ============ -->
        
        <pef:pef2text breaks="DEFAULT" pad="BOTH">
            <p:input port="source">
                <p:pipe step="pef" port="result"/>
            </p:input>
            <p:with-option name="href" select="concat($output-dir-uri,replace(p:base-uri(/),'^.*/([^/]*)\.[^/\.]*$','$1'),'.brf')">
                <p:pipe step="dtbook-to-brf" port="source"/>
            </p:with-option>
            <p:with-option name="table" select="$table"/>
        </pef:pef2text>
        
        <!-- ============ -->
        <!-- STORE AS PEF -->
        <!-- ============ -->
        
        <p:identity>
            <p:input port="source">
                <p:pipe step="pef" port="result"/>
            </p:input>
        </p:identity>
        <p:choose>
            <p:when test="$pef='true'">
                <p:store indent="true" encoding="utf-8" omit-xml-declaration="false">
                    <p:input port="source">
                        <p:pipe step="pef" port="result"/>
                    </p:input>
                    <p:with-option name="href" select="concat($output-dir-uri,replace(p:base-uri(/),'^.*/([^/]*)\.[^/\.]*$','$1'),'.pef.xml')">
                        <p:pipe step="dtbook-to-brf" port="source"/>
                    </p:with-option>
                </p:store>
            </p:when>
            <p:otherwise>
                <p:sink/>
            </p:otherwise>
        </p:choose>
        
        <!-- ==================== -->
        <!-- STORE AS PEF PREVIEW -->
        <!-- ==================== -->
        
        <p:identity>
            <p:input port="source">
                <p:pipe step="pef" port="result"/>
            </p:input>
        </p:identity>
        <p:choose>
            <p:when test="$preview='true'">
                <px:pef-to-html.convert/>
                <p:store indent="true" encoding="utf-8" method="xhtml" omit-xml-declaration="false"
                    doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
                    <p:with-option name="href" select="concat($output-dir-uri,replace(p:base-uri(/),'^.*/([^/]*)\.[^/\.]*$','$1'),'.pef.html')">
                        <p:pipe step="dtbook-to-brf" port="source"/>
                    </p:with-option>
                </p:store>
            </p:when>
            <p:otherwise>
                <p:sink/>
            </p:otherwise>
        </p:choose>
    </p:group>
    
</p:declare-step>
