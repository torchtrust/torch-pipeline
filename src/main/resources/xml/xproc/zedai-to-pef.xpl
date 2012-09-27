<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step
    xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:px="http://www.daisy.org/ns/pipeline/xproc"
    xmlns:torch="http://www.torchtrust.org/pipeline"
    xmlns:d="http://www.daisy.org/ns/pipeline/data"
    exclude-inline-prefixes="px d torch"
    type="torch:zedai-to-pef" version="1.0">

    <p:documentation xmlns="http://www.w3.org/1999/xhtml">
        <h1 px:role="name">ZedAI to PEF (Torch Trust)</h1>
        <p px:role="desc">Transforms a ZedAI (DAISY 4 XML) document into an PEF, following Torch Trust transcription rules.</p>
        <dl px:role="author">
            <dt>Name:</dt>
            <dd px:role="name">Paul Wood</dd>
            <dt>Organization:</dt>
            <dd px:role="organization" href="http://www.torchtrust.org/">Torch Trust</dd>
            <dt>E-mail:</dt>
            <dd><a px:role="contact" href="mailto:paulw.torchtrust@gmail.com">paulw.torchtrust@gmail.com</a></dd>
        </dl>
    </p:documentation>

    <p:input port="source" primary="true" px:name="source" px:media-type="application/z3998-auth+xml">
        <p:documentation>
            <h2 px:role="name">source</h2>
            <p px:role="desc">Input ZedAI.</p>
        </p:documentation>
    </p:input>
    
    <p:option name="output-dir" required="true" px:output="result" px:sequence="false" px:type="anyDirURI">
        <p:documentation>
            <h2 px:role="name">output-dir</h2>
            <p px:role="desc">Path to output directory for the PEF.</p>
        </p:documentation>
    </p:option>
    
    <p:option name="temp-dir" required="true" px:output="temp" px:sequence="false" px:type="anyDirURI">
        <p:documentation>
            <h2 px:role="name">temp-dir</h2>
            <p px:role="desc">Path to directory for storing temporary files.</p>
        </p:documentation>
    </p:option>
    
    <p:option name="preview" required="false" px:type="boolean" select="'false'">
        <p:documentation>
            <h2 px:role="name">preview</h2>
            <p px:role="desc">Whether or not to include a preview of the PEF in HTML (true or false).</p>
        </p:documentation>
    </p:option>
    
    <p:import href="http://www.daisy.org/pipeline/modules/braille/zedai-to-pef/xproc/zedai-to-pef.xpl"/>

    <p:variable name="stylesheet" select="'http://www.torchtrust.org/pipeline/braille/zedai.css'"/>
    <p:variable name="preprocessor" select="''"/>
    <p:variable name="translator" select="'http://www.torchtrust.org/pipeline/braille/zedai-translator.xpl'"/>

    <!-- ============ -->
    <!-- ZEDAI TO PEF -->
    <!-- ============ -->
    
    <px:zedai-to-pef>
        <p:with-option name="stylesheet" select="$stylesheet">
            <p:empty/>
        </p:with-option>
        <p:with-option name="preprocessor" select="$preprocessor">
            <p:empty/>
        </p:with-option>
        <p:with-option name="translator" select="$translator">
            <p:empty/>
        </p:with-option>
        <p:with-option name="preview" select="$preview">
            <p:empty/>
        </p:with-option>
        <p:with-option name="output-dir" select="$output-dir">
            <p:empty/>
        </p:with-option>
        <p:with-option name="temp-dir" select="$temp-dir">
            <p:empty/>
        </p:with-option>
    </px:zedai-to-pef>
    
</p:declare-step>
