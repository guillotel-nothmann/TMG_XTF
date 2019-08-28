<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" extension-element-prefixes="session" version="2.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:editURL="http://cdlib.org/xtf/editURL" xmlns:session="java:org.cdlib.xtf.xslt.Session" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xtf="http://cdlib.org/xtf">
    <xsl:param name="lang" select="
            if (normalize-space(session:getData('lang')) != '') then
                session:getData('lang')
            else
                'en'" />
    <xsl:param name="transTable" select="document(concat('g10n/translation_', $lang, '.xml'))" />
    <xsl:param name="abb" select="
            if (normalize-space(session:getData('abb')) != '') then
                session:getData('abb')
            else
                'false'" />
    <xsl:param name="orig" select="
            if (normalize-space(session:getData('orig')) != '') then
                session:getData('orig')
            else
                'false'" />
    <xsl:param name="pc" select="
            if (normalize-space(session:getData('pc')) != '') then
                session:getData('pc')
            else
                'false'" />
    <xsl:param name="lb" select="
            if (normalize-space(session:getData('lb')) != '') then
                session:getData('lb')
            else
                'false'" />
    <xsl:param name="names" select="
            if (normalize-space(session:getData('names')) != '') then
                session:getData('names')
            else
                'true'" />
    <xsl:param name="works" select="
            if (normalize-space(session:getData('works')) != '') then
                session:getData('works')
            else
                'true'" />
    <xsl:param name="places" select="
            if (normalize-space(session:getData('places')) != '') then
                session:getData('places')
            else
                'true'" />
    <xsl:param name="thesaurus" select="
            if (normalize-space(session:getData('thesaurus')) != '') then
                session:getData('thesaurus')
            else
                'false'" />
    <xsl:param name="internal" select="
            if (normalize-space(session:getData('internal')) != '') then
                session:getData('internal')
            else
                'true'" />
    <xsl:param name="add" select="
            if (normalize-space(session:getData('add')) != '') then
                session:getData('add')
            else
                'false'" />
    <xsl:param name="del" select="
            if (normalize-space(session:getData('del')) != '') then
                session:getData('del')
            else
                'false'" />
    <xsl:param name="corr" select="
            if (normalize-space(session:getData('corr')) != '') then
                session:getData('corr')
            else
                'false'" />
    <xsl:param name="sic" select="
            if (normalize-space(session:getData('sic')) != '') then
                session:getData('sic')
            else
                'false'" />
    <xsl:param name="musicEmend" select="
            if (normalize-space(session:getData('musicEmend')) != '') then
                session:getData('musicEmend')
            else
                'false'" />
    <xsl:param name="musicOriginal" select="
            if (normalize-space(session:getData('musicOriginal')) != '') then
                session:getData('musicOriginal')
            else
                'false'" />
    <!-- ====================================================================== -->
    <!-- URL Encoding                                                           -->
    <!-- ====================================================================== -->
    <xsl:function name="xtf:urlEncode">
        <xsl:param name="string" />
        <xsl:variable name="string1" select="replace(replace($string, '^ +', ''), ' +$', '')" />
        <xsl:variable name="string2" select="replace($string1, '%', '%25')" />
        <xsl:variable name="string3" select="replace($string2, ' +', '%20')" />
        <xsl:variable name="string4" select="replace($string3, '#', '%23')" />
        <xsl:variable name="string5" select="replace($string4,'&amp;','%26')" />
        <xsl:variable name="string6" select="replace($string5, '\+', '%2B')" />
        <xsl:variable name="string7" select="replace($string6, '/', '%2F')" />
        <xsl:variable name="string8" select="replace($string7, '&lt;', '%3C')" />
        <xsl:variable name="string9" select="replace($string8, '=', '%3D')" />
        <xsl:variable name="string10" select="replace($string9, '>', '%3E')" />
        <xsl:variable name="string11" select="replace($string10, '\?', '%3F')" />
        <xsl:variable name="string12" select="replace($string11, ':', '%3A')" />
        <xsl:value-of select="$string12" />
    </xsl:function>
    <!-- ====================================================================== -->
    <!-- Utility functions for handy editing of URLs                           -->
    <!-- ====================================================================== -->
    <!-- Function to set the value of a URL parameter, replacing the old value 
        of that parameter if any.
    -->
    <xsl:function name="editURL:set">
        <xsl:param name="url" />
        <xsl:param name="param" />
        <xsl:param name="value" />
        <!-- Protect ampersands, semicolons, etc. in the value so they 
            don't get interpreted as URL parameter separators. -->
        <xsl:variable name="protectedValue" select="editURL:protectValue($value)" />
        <xsl:variable name="regex" select="concat('(^|;)', $param, '[^;]*(;|$)')" />
        <xsl:choose>
            <xsl:when test="matches($url, $regex)">
                <xsl:value-of select="editURL:clean(replace($url, $regex, concat(';', $param, '=', $protectedValue, ';')))" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="editURL:clean(concat($url, ';', $param, '=', $protectedValue))" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    <!-- Function to remove a URL parameter, if it exists in the URL -->
    <xsl:function name="editURL:remove">
        <xsl:param name="url" />
        <xsl:param name="param" />
        <xsl:variable name="regex" select="concat('(^|;)', $param, '[^;]*(;|$)')" />
        <xsl:value-of select="editURL:clean(replace($url, $regex, ';'))" />
    </xsl:function>
    <!-- Utility function to escape characters that have special meaning in a regular
        expression. Call this when passing raw values in 'param' to editURL:remove.
        
        From the XPath specification:
        [10] Char ::= [^.\?*+{}()|^$#x5B#x5D]
        The characters #x5B and #x5D correspond to "[" and "]" respectively.  
    -->
    <xsl:function name="editURL:escapeRegex">
        <xsl:param name="val" />
        <xsl:value-of select="replace($val, '([.\\?*+{}()|^\[\]$])', '\\$1')" />
    </xsl:function>
    <!-- Utility function to escape ampersands, equal signs, and other characters
        that have special meaning in a URL. -->
    <xsl:function name="editURL:protectValue">
        <xsl:param name="value" />
        <xsl:value-of select="replace(replace(replace(replace(replace(replace($value,             '%',     '%25'),             '[+]',   '%2B'),             '&amp;', '%26'),              ';',     '%3B'),              '=',     '%3D'),             '#',     '%23')" />
    </xsl:function>
    <!-- Function to replace an empty URL with a value. If the URL isn't empty
        it is returned unchanged. By the way, certain parameters such as
        "expand" are still counted as empty.
    -->
    <xsl:function name="editURL:replaceEmpty">
        <xsl:param name="url" />
        <xsl:param name="replacement" />
        <xsl:choose>
            <xsl:when test="matches(editURL:clean($url), '^(expand=[^;]*)*$')">
                <xsl:value-of select="$replacement" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$url" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    <!-- Function to clean up a URL, removing leading and trailing ';' chars, etc. -->
    <xsl:function name="editURL:clean">
        <xsl:param name="v0" />
        <!-- Change old ampersands to new easy-to-read semicolons -->
        <xsl:variable name="v1" select="replace($v0, '&amp;([^&amp;=;]+=)', ';$1')" />
        <!-- Get rid of empty parameters -->
        <xsl:variable name="v2" select="replace($v1, '[^;=]+=(;|$)', '')" />
        <!-- Replace ";;" with ";" -->
        <xsl:variable name="v3" select="replace($v2, ';;+', ';')" />
        <!-- Get rid of leading and trailing ';' -->
        <xsl:variable name="v4" select="replace($v3, '^;|;$', '')" />
        <!-- All done. -->
        <xsl:value-of select="$v4" />
    </xsl:function>
    <!-- Function to calculate an unused name for the next facet parameter -->
    <xsl:function name="editURL:nextFacetParam">
        <xsl:param name="queryString" />
        <xsl:param name="field" />
        <xsl:variable name="nums">
            <num n="0" />
            <xsl:analyze-string regex="(^|;)f([0-9]+)-" select="$queryString">
                <xsl:matching-substring>
                    <num n="{number(regex-group(2))}" />
                </xsl:matching-substring>
            </xsl:analyze-string>
        </xsl:variable>
        <xsl:value-of select="concat('f', 1 + max(($nums/*/@n)), '-', $field)" />
    </xsl:function>
    <!-- ====================================================================== -->
    <!-- Localization Templates                                                 -->
    <!-- ====================================================================== -->
    <xsl:template name="translate">
        <xsl:param name="resultTree" />
        <xsl:choose>
            <xsl:when test="$lang = 'en'">
                <xsl:copy-of select="$resultTree" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates mode="translate" select="$resultTree" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="*" mode="translate">
        <xsl:element name="{name(.)}">
            <xsl:copy-of select="@*" />
            <xsl:apply-templates mode="translate" />
        </xsl:element>
    </xsl:template>
    <xsl:template match="*:input[matches(@*:type, 'submit|reset')]" mode="translate">
        <xsl:variable name="string" select="@value" />
        <xsl:element name="{name(.)}">
            <xsl:copy-of select="@*[not(name() = 'value')]" />
            <xsl:if test="$string">
                <xsl:attribute name="value">
                    <xsl:call-template name="tString">
                        <xsl:with-param name="string" select="$string" />
                    </xsl:call-template>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates mode="translate" />
        </xsl:element>
    </xsl:template>
    <xsl:template match="text()" mode="translate">
        <xsl:variable name="string" select="." />
        <!-- might need a switch here that checks if parent is a protected div/span element -->
        <xsl:call-template name="tString">
            <xsl:with-param name="string" select="$string" />
        </xsl:call-template>
    </xsl:template>
    <xsl:template name="tString">
        <xsl:param name="string" />
        <xsl:choose>
            <!-- full match -->
            <xsl:when test="$transTable/transTable/trans[from/text() = $string]">
                <xsl:value-of select="$transTable/transTable/trans[from/text() = $string]/to" />
            </xsl:when>
            <!-- partial match -->
            <xsl:when test="$transTable/transTable/trans/from[contains($string, .)]">
                <xsl:value-of select="replace($string, $transTable/transTable/trans[contains($string, from)][1]/from, $transTable/transTable/trans[contains($string, from)][1]/to)" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$string" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="getLang">
        <!--<xsl:variable name="lang" select="session:getData('lang')"/>-->
        <html lang="en" xml:lang="en">
            <head>
                <title>XTF: Set Language</title>
                <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
                <xsl:copy-of select="$brand.links" />
            </head>
            <body>
                <xsl:copy-of select="$brand.header" />
                <div>
                    <h2>Set Language</h2>
                    <form action="/xtf/search" method="get">
                        <input name="lang" type="radio" value="en">
                            <xsl:if test="$lang = 'en'"><xsl:attribute name="checked" select="'checked'" /></xsl:if>
                            <xsl:text>Engish</xsl:text>
                        </input>&#160;&#160; <input name="lang" type="radio" value="fr">
                            <xsl:if test="$lang = 'fr'"><xsl:attribute name="checked" select="'checked'" /></xsl:if>
                            <xsl:text>French</xsl:text>
                        </input>&#160; <input name="lang" type="radio" value="de">
                            <xsl:if test="$lang = 'de'"><xsl:attribute name="checked" select="'checked'" /></xsl:if>
                            <xsl:text>German</xsl:text>
                        </input>&#160; <input type="submit" value="submit" />
                        <input name="smode" type="hidden" value="setLang" />
                    </form>
                </div>
            </body>
        </html>
    </xsl:template>
    <xsl:template name="setLang">
        <xsl:value-of select="session:setData('lang', $lang)" />
        <html lang="fr" xml:lang="fr">
            <head>
                <title>XTF: Success</title>
                <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
                <xsl:copy-of select="$brand.links" />
            </head>
            <body onload="autoCloseTimer = setTimeout('window.close()', 1000); opener.top.location.reload();">
                <!-- How are we going to reload previous window? -->
                <xsl:copy-of select="$brand.header" />
                <h1>Language Set</h1>
                <b>
                    <xsl:text>Your language has been set to </xsl:text>
                    <xsl:value-of select="
                            if ($lang = 'sp') then
                                'Spanish'
                            else
                                if ($lang = 'fr') then
                                    'French'
                                else
                                    if ($lang = 'it') then
                                        'Italian'
                                    else
                                        if ($lang = 'de') then
                                            'German'
                                        else
                                            'English'" />
                </b>
            </body>
        </html>
    </xsl:template>
    <xsl:template name="getEdit">
        <div class="getEdit">
            <h2>TMG: Edition</h2>
            <form>
                <table border="0" width="100%">
                    <tr>
                        <td colspan="3">
                            <b>Regularization and Normalization:</b>
                        </td>
                    </tr>
                    <tr>
                        <td width="5%" />
                        <td width="75%">
                            <input name="abb" type="hidden" value="false" />
                            <input name="abb" type="checkbox" value="true">
                                <xsl:if test="$abb = 'true'">
                                    <xsl:attribute name="checked" select="'checked'" />
                                </xsl:if>
                                <xsl:text>Keep abbreviations</xsl:text>
                            </input>
                        </td>
                    </tr>
                    <tr>
                        <td width="5%" />
                        <td width="75%">
                            <input name="orig" type="hidden" value="false" />
                            <input name="orig" type="checkbox" value="true">
                                <xsl:if test="$orig = 'true'">
                                    <xsl:attribute name="checked" select="'checked'" />
                                </xsl:if>
                                <xsl:text>Keep typographical variants</xsl:text>
                            </input>
                        </td>
                    </tr>
                    <tr>
                        <td width="5%" />
                        <td width="75%">
                            <input name="pc" type="hidden" value="false" />
                            <input name="pc" type="checkbox" value="true">
                                <xsl:if test="$pc = 'true'">
                                    <xsl:attribute name="checked" select="'checked'" />
                                </xsl:if>
                                <xsl:text>Keep punctuation</xsl:text>
                            </input>
                        </td>
                    </tr>
                    <tr>
                        <td width="5%" />
                        <td width="75%">
                            <input name="lb" type="hidden" value="false" />
                            <input name="lb" type="checkbox" value="true">
                                <xsl:if test="$lb = 'true'">
                                    <xsl:attribute name="checked" select="'checked'" />
                                </xsl:if>
                                <xsl:text>Keep line breaks</xsl:text>
                            </input>
                        </td>
                    </tr>
                    <!--<tr>
                                <td width="5%"></td>
                                <td width="75%">
                                    <input type="hidden" name="musicOriginal" value="false"/>
                                    <input type="checkbox" name="musicOriginal" value="true"> 
                                        <xsl:if test="$musicOriginal='true'">
                                            <xsl:attribute name="checked" select="'checked'"/>
                                        </xsl:if>
                                        <xsl:text>Keep original time signatures and keys</xsl:text>
                                    </input>
                                </td> 
                            </tr>-->
                    <tr>
                        <td colspan="3">
                            <b>Additions, Deletions and Corrections:</b>
                        </td>
                    </tr>
                    <tr>
                        <td width="5%" />
                        <td width="75%">
                            <input name="add" type="hidden" value="false" />
                            <input name="add" type="checkbox" value="true">
                                <xsl:if test="$add = 'true'">
                                    <xsl:attribute name="checked" select="'checked'" />
                                </xsl:if>
                                <xsl:text>Highlight additions</xsl:text>
                            </input>
                        </td>
                    </tr>
                    <tr>
                        <td width="5%" />
                        <td width="75%">
                            <input name="del" type="hidden" value="false" />
                            <input name="del" type="checkbox" value="true">
                                <xsl:if test="$del = 'true'">
                                    <xsl:attribute name="checked" select="'checked'" />
                                </xsl:if>
                                <xsl:text>Highlight and show deletions</xsl:text>
                            </input>
                        </td>
                    </tr>
                    <tr>
                        <td width="5%" />
                        <td width="75%">
                            <input name="corr" type="hidden" value="false" />
                            <input name="corr" type="checkbox" value="true">
                                <xsl:if test="$corr = 'true'">
                                    <xsl:attribute name="checked" select="'checked'" />
                                </xsl:if>
                                <xsl:text>Highlight corrections</xsl:text>
                            </input>
                        </td>
                    </tr>
                    <tr>
                        <td width="5%" />
                        <td width="75%">
                            <input name="sic" type="hidden" value="false" />
                            <input name="sic" type="checkbox" value="true">
                                <xsl:if test="$sic = 'true'">
                                    <xsl:attribute name="checked" select="'checked'" />
                                </xsl:if>
                                <xsl:text>Highlight and show errors</xsl:text>
                            </input>
                        </td>
                    </tr>
                    <!--<tr>
                                <td width="5%"></td>
                                <td width="75%">
                                    <input type="hidden" name="musicEmend" value="false"/>
                                    <input type="checkbox" name="musicEmend" value="true">
                                        <xsl:if test="$musicEmend='true'">
                                            <xsl:attribute name="checked" select="'checked'"/>
                                        </xsl:if>
                                        <xsl:text>Display emendations in musical examples</xsl:text>
                                    </input>
                                </td>
                            </tr>-->
                    <tr>
                        <td colspan="3">
                            <b>Hyperlinks:</b>
                        </td>
                    </tr>
                    <tr>
                        <td width="5%" />
                        <td width="75%">
                            <input name="names" type="hidden" value="false" />
                            <input name="names" type="checkbox" value="true">
                                <xsl:if test="$names = 'true'">
                                    <xsl:attribute name="checked" select="'checked'" />
                                </xsl:if>
                                <xsl:text>Links for names</xsl:text>
                            </input>
                        </td>
                    </tr>
                    <tr>
                        <td width="5%" />
                        <td width="75%">
                            <input name="works" type="hidden" value="false" />
                            <input name="works" type="checkbox" value="true">
                                <xsl:if test="$works = 'true'">
                                    <xsl:attribute name="checked" select="'checked'" />
                                </xsl:if>
                                <xsl:text>Links for works</xsl:text>
                            </input>
                        </td>
                    </tr>
                    <tr>
                        <td width="5%" />
                        <td width="75%">
                            <input name="places" type="hidden" value="false" />
                            <input name="places" type="checkbox" value="true">
                                <xsl:if test="$places = 'true'">
                                    <xsl:attribute name="checked" select="'checked'" />
                                </xsl:if>
                                <xsl:text>Links for places</xsl:text>
                            </input>
                        </td>
                    </tr>
                    <tr>
                        <td width="5%" />
                        <td width="75%">
                            <input name="thesaurus" type="hidden" value="false" />
                            <input name="thesaurus" type="checkbox" value="true">
                                <xsl:if test="$thesaurus = 'true'">
                                    <xsl:attribute name="checked" select="'checked'" />
                                </xsl:if>
                                <xsl:text>Links for thesaurus</xsl:text>
                            </input>
                        </td>
                    </tr>
                    <tr>
                        <td width="5%" />
                        <td width="75%">
                            <input name="internal" type="hidden" value="false" />
                            <input name="internal" type="checkbox" value="true">
                                <xsl:if test="$internal = 'true'">
                                    <xsl:attribute name="checked" select="'checked'" />
                                </xsl:if>
                                <xsl:text>Links for internal references</xsl:text>
                            </input>
                        </td>
                    </tr>
                </table>
                <input name="smode" type="hidden" value="setEdit" />
            </form>
            <button class="mdc-button mdc-button--outlined">Submit</button>
        </div>
    </xsl:template>
    <xsl:template name="setEdit">
        <xsl:value-of select="session:setData('abb', $abb)" />
        <xsl:value-of select="session:setData('orig', $orig)" />
        <xsl:value-of select="session:setData('pc', $pc)" />
        <xsl:value-of select="session:setData('lb', $lb)" />
        <xsl:value-of select="session:setData('names', $names)" />
        <xsl:value-of select="session:setData('works', $works)" />
        <xsl:value-of select="session:setData('places', $places)" />
        <xsl:value-of select="session:setData('thesaurus', $thesaurus)" />
        <xsl:value-of select="session:setData('internal', $internal)" />
        <xsl:value-of select="session:setData('add', $add)" />
        <xsl:value-of select="session:setData('del', $del)" />
        <xsl:value-of select="session:setData('corr', $corr)" />
        <xsl:value-of select="session:setData('sic', $sic)" />
        <xsl:value-of select="session:setData('musicEmend', $musicEmend)" />
        <xsl:value-of select="session:setData('musicOriginal', $musicOriginal)" />
        <html lang="en" xml:lang="en">
            <head>
                <title>TMG: Success</title>
                <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
                <xsl:copy-of select="$brand.links" />
            </head>
            <body onload="autoCloseTimer = setTimeout('window.close()', 5000); opener.top.location.reload();">
                <xsl:copy-of select="$brand.header" />
                <h1>Edition Set</h1>
                <b>
                    <xsl:text>Edition parameters have been set to :</xsl:text>
                </b>
                <table border="0" width="100%">
                    <tr>
                        <td colspan="3">
                            <b>Regularization and Normalization:</b>
                        </td>
                    </tr>
                    <tr>
                        <td width="5%" />
                        <td width="75%">Keep abbreviations:</td>
                        <td width="20%">
                            <xsl:value-of select="
                                    if ($abb = 'true') then
                                        'true'
                                    else
                                        'false'" />
                        </td>
                    </tr>
                    <tr>
                        <td width="5%" />
                        <td width="75%">Keep typographical variants:</td>
                        <td width="20%">
                            <xsl:value-of select="
                                    if ($orig = 'true') then
                                        'true'
                                    else
                                        'false'" />
                        </td>
                    </tr>
                    <tr>
                        <td width="5%" />
                        <td width="75%">Keep punctuation:</td>
                        <td width="20%">
                            <xsl:value-of select="
                                    if ($pc = 'true') then
                                        'true'
                                    else
                                        'false'" />
                        </td>
                    </tr>
                    <tr>
                        <td width="5%" />
                        <td width="75%">Keep line breaks:</td>
                        <td width="20%">
                            <xsl:value-of select="
                                    if ($lb = 'true') then
                                        'true'
                                    else
                                        'false'" />
                        </td>
                    </tr>
                    <tr>
                        <td width="5%" />
                        <td width="75%">Keep original time signatures and keys:</td>
                        <td width="20%">
                            <xsl:value-of select="
                                    if ($musicOriginal = 'true') then
                                        'true'
                                    else
                                        'false'" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="3">
                            <b>Additions, Deletions, Corrections and Errors:</b>
                        </td>
                    </tr>
                    <tr>
                        <td width="5%" />
                        <td width="75%">Highlight additions:</td>
                        <td width="20%">
                            <xsl:value-of select="
                                    if ($add = 'true') then
                                        'true'
                                    else
                                        'false'" />
                        </td>
                    </tr>
                    <tr>
                        <td width="5%" />
                        <td width="75%">Highlight and show deletions:</td>
                        <td width="20%">
                            <xsl:value-of select="
                                    if ($del = 'true') then
                                        'true'
                                    else
                                        'false'" />
                        </td>
                    </tr>
                    <tr>
                        <td width="5%" />
                        <td width="75%">Highlight corrections:</td>
                        <td width="20%">
                            <xsl:value-of select="
                                    if ($corr = 'true') then
                                        'true'
                                    else
                                        'false'" />
                        </td>
                    </tr>
                    <tr>
                        <td width="5%" />
                        <td width="75%">Highlight errors:</td>
                        <td width="20%">
                            <xsl:value-of select="
                                    if ($sic = 'true') then
                                        'true'
                                    else
                                        'false'" />
                        </td>
                    </tr>
                    <!--<tr>
                            <td width="5%"></td>
                            <td width="75%">Display emendations in musical examples:</td>
                            <td width="20%">
                                <xsl:value-of select="if ($musicEmend='true') then 'true' else 'false'"/>
                            </td>
                        </tr>-->
                    <tr>
                        <td colspan="3">
                            <b>Hyperlinks:</b>
                        </td>
                    </tr>
                    <tr>
                        <td width="5%" />
                        <td width="75%">Links for names:</td>
                        <td width="20%">
                            <xsl:value-of select="
                                    if ($names = 'true') then
                                        'true'
                                    else
                                        'false'" />
                        </td>
                    </tr>
                    <tr>
                        <td width="5%" />
                        <td width="75%">Links for works:</td>
                        <td width="20%">
                            <xsl:value-of select="
                                    if ($works = 'true') then
                                        'true'
                                    else
                                        'false'" />
                        </td>
                    </tr>
                    <tr>
                        <td width="5%" />
                        <td width="75%">Links for places:</td>
                        <td width="20%">
                            <xsl:value-of select="
                                    if ($places = 'true') then
                                        'true'
                                    else
                                        'false'" />
                        </td>
                    </tr>
                    <tr>
                        <td width="5%" />
                        <td width="75%">Links for thesaurus:</td>
                        <td width="20%">
                            <xsl:value-of select="
                                    if ($thesaurus = 'true') then
                                        'true'
                                    else
                                        'false'" />
                        </td>
                    </tr>
                    <tr>
                        <td width="5%" />
                        <td width="75%">Links for internal references:</td>
                        <td width="20%">
                            <xsl:value-of select="
                                    if ($internal = 'true') then
                                        'true'
                                    else
                                        'false'" />
                        </td>
                    </tr>
                </table>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
