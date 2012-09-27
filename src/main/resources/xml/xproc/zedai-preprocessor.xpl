<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step
    xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:px="http://www.daisy.org/ns/pipeline/xproc"
    xmlns:torch="http://www.torchtrust.org/pipeline"
    exclude-inline-prefixes="px torch"
    type="torch:zedai-preprocessor" version="1.0">

    <p:input port="source" primary="true" px:media-type="application/z3998-auth+xml"/>
    <p:output port="result" primary="true" px:media-type="application/z3998-auth+xml"/>
    
    <!-- Italic fix -->
    
    <p:xslt>
        <p:input port="stylesheet">
            <p:document href="../xslt/zedai-italic-fix.xsl"/>
        </p:input>
        <p:input port="parameters">
            <p:empty/>
        </p:input>
    </p:xslt>
    
    <!-- Poetry fix -->
    
    <p:xslt>
        <p:input port="stylesheet">
            <p:document href="../xslt/zedai-poetry-fix.xsl"/>
        </p:input>
        <p:input port="parameters">
            <p:empty/>
        </p:input>
    </p:xslt>
    
</p:declare-step>
