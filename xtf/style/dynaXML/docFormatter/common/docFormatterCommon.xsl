<xsl:stylesheet exclude-result-prefixes="#all" extension-element-prefixes="session" version="2.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:session="java:org.cdlib.xtf.xslt.Session" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xtf="http://cdlib.org/xtf">
   <!-- ====================================================================== -->
   <!-- Common DynaXML Stylesheet                                              -->
   <!-- ====================================================================== -->
   <!--
      Copyright (c) 2008, Regents of the University of California
      All rights reserved.
      
      Redistribution and use in source and binary forms, with or without 
      modification, are permitted provided that the following conditions are 
      met:
      
      - Redistributions of source code must retain the above copyright notice, 
      this list of conditions and the following disclaimer.
      - Redistributions in binary form must reproduce the above copyright 
      notice, this list of conditions and the following disclaimer in the 
      documentation and/or other materials provided with the distribution.
      - Neither the name of the University of California nor the names of its
      contributors may be used to endorse or promote products derived from 
      this software without specific prior written permission.
      
      THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
      AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
      IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
      ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
      LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
      CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
      SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
      INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
      CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
      ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
      POSSIBILITY OF SUCH DAMAGE.
   -->
   <!-- ====================================================================== -->
   <!-- Import Stylesheets                                                     -->
   <!-- ====================================================================== -->
   <xsl:import href="../../../xtfCommon/xtfCommon.xsl" />
   <!-- ====================================================================== -->
   <!-- Global Keys                                                            -->
   <!-- ====================================================================== -->
   <xsl:key match="xtf:hit" name="hit-num-dynamic" use="@hitNum" />
   <xsl:key match="xtf:hit" name="hit-rank-dynamic" use="@rank" />
   <!-- ====================================================================== -->
   <!-- Global Parameters                                                      -->
   <!-- ====================================================================== -->
   <!-- Path Parameters -->
   <xsl:param name="servlet.path" />
   <xsl:param name="root.path" />
   <xsl:param name="xtfURL" select="$root.path" />
   <xsl:param name="dynaxmlPath" select="
         if (matches($servlet.path, 'org.cdlib.xtf.crossQuery.CrossQuery')) then
            'org.cdlib.xtf.dynaXML.DynaXML'
         else
            'view'" />
   <xsl:param name="docId" />
   <xsl:param name="docPath" select="replace($docId, '[^/]+\.xml$', '')" />
   <xsl:param name="http.URL" />
   <!-- If an external 'source' document was specified, include it in the
      query string of links we generate. -->
   <xsl:param name="source" select="''" />
   <xsl:variable name="sourceStr">
      <xsl:if test="$source">;source=<xsl:value-of select="$source" /></xsl:if>
   </xsl:variable>
   <xsl:param name="query.string" select="concat('docId=', $docId, $sourceStr)" />
   <xsl:param name="doc.path"><xsl:value-of select="$xtfURL" /><xsl:value-of select="$dynaxmlPath" />?<xsl:value-of select="$query.string" /></xsl:param>
   <xsl:variable name="systemId" select="saxon:systemId()" xmlns:saxon="http://saxon.sf.net/" />
   <xsl:param name="doc.dir">
      <xsl:choose>
         <xsl:when test="starts-with($systemId, 'http://')">
            <xsl:value-of select="replace($systemId, '/[^/]*$', '')" />
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="concat($xtfURL, 'data/', $docPath)" />
         </xsl:otherwise>
      </xsl:choose>
   </xsl:param>
   <xsl:param name="figure.path" select="concat($doc.dir, '/figures/')" />
   <xsl:param name="cooc.path" select="concat($doc.dir, '/cooccurrence/')" />
   <xsl:param name="midi.path" select="concat($doc.dir, '/midi/')" />
   <xsl:param name="mei.path" select="concat($doc.dir, '/mei/')" />
   <xsl:param name="index.path" select="concat($xtfURL, 'data/tei/index/')" />
   <!--  "concat($doc.dir, '/index/')"/>-->
   <xsl:param name="pdf.path" select="concat($doc.dir, '/pdfs/')" />
   <xsl:variable name="doc.adress" select="replace($doc.path, 'view\?docId=tei', 'data/tei')" />
   <xsl:variable name="fac.dir" select="document($doc.adress)//*:sourceDesc//*:listWit/*:witness/*:bibl/*:ptr/@target" />
   <!-- établir le lien -->
   <xsl:param name="indexS.path">
      <!--<xsl:choose>
         <xsl:when test=" ends-with($docPath, 'index/')">
            
         </xsl:when>
         <xsl:otherwise>
             <xsl:value-of>tei/index/</xsl:value-of>
         </xsl:otherwise>
      </xsl:choose>-->
      <xsl:value-of>tei/index/</xsl:value-of>
   </xsl:param>
   <!-- navigation parameters -->
   <xsl:param name="doc.view" select="'0'" />
   <xsl:param name="toc.depth" select="1" />
   <xsl:param name="anchor.id" select="'0'" />
   <xsl:param name="set.anchor" select="'0'" />
   <xsl:param name="chunk.id" />
   <xsl:param name="toc.id" />
   <!-- search parameters -->
   <xsl:param name="query" />
   <xsl:param name="query-join" />
   <xsl:param name="query-exclude" />
   <xsl:param name="sectionType" />
   <xsl:param name="search">
      <xsl:if test="$query">
         <xsl:value-of select="concat(';query=', replace($query, ';', '%26'))" />
      </xsl:if>
      <xsl:if test="$query-join">
         <xsl:value-of select="concat(';query-join=', $query-join)" />
      </xsl:if>
      <xsl:if test="$query-exclude">
         <xsl:value-of select="concat(';query-exclude=', $query-exclude)" />
      </xsl:if>
      <xsl:if test="$sectionType">
         <xsl:value-of select="concat(';sectionType=', $sectionType)" />
      </xsl:if>
   </xsl:param>
   <xsl:param name="hit.rank" select="'0'" />
   <!-- Branding Parameters -->
   <xsl:param name="brand" select="'default'" />
   <xsl:variable name="brand.file">
      <xsl:choose>
         <xsl:when test="$brand != ''">
            <xsl:copy-of select="document(concat('../../../../brand/', $brand, '.xml'))" />
         </xsl:when>
         <xsl:otherwise>
            <xsl:copy-of select="document('../../../../brand/default.xml')" />
         </xsl:otherwise>
      </xsl:choose>
   </xsl:variable>
   <xsl:param name="brand.links" select="$brand.file/brand/dynaxml.links/*" xpath-default-namespace="http://www.w3.org/1999/xhtml" />
   <xsl:param name="brand.header" select="$brand.file/brand/dynaxml.header/*" xpath-default-namespace="http://www.w3.org/1999/xhtml" />
   <xsl:param name="brand.footer" select="$brand.file/brand/footer/*" xpath-default-namespace="http://www.w3.org/1999/xhtml" />
   <!-- Special Robot Parameters -->
   <xsl:param name="http.user-agent" />
   <!-- WARNING: Inclusion of 'Wget' is for testing only, please remove before going into production -->
   <xsl:param name="robots" select="'Googlebot|Slurp|msnbot|Teoma|Wget'" />
   <!-- ====================================================================== -->
   <!-- Button Bar Templates                                                   -->
   <!-- ====================================================================== -->
   <xsl:template name="bbar">
      <xsl:call-template name="translate">
         <xsl:with-param name="resultTree">
            <html lang="fr" xml:lang="fr">
               <head>
                  <title>
                     <xsl:value-of select="$doc.title" />
                  </title>
                  <link href="{$css.path}bbar.css" rel="stylesheet" type="text/css" />
                  <link href="icons/default/favicon.ico" rel="shortcut icon" />
                  <script src="https://unpkg.com/material-components-web@latest/dist/material-components-web.min.js" />
                  <link href="https://fonts.googleapis.com/icon?family=Material+Icons+Two+Tone" rel="stylesheet" />
                  <link href="https://unpkg.com/material-components-web@latest/dist/material-components-web.min.css" rel="stylesheet" />
               </head>
               <body>
                  <xsl:copy-of select="$brand.header" />
                  <header class="mdc-top-app-bar mdc-top-app-bar--dense">
                     <div class="mdc-top-app-bar__row tt">
                        <section class="mdc-top-app-bar__section mdc-top-app-bar__section--align-start">
                           <button class="material-icons-two-tone mdc-top-app-bar__navigation-icon mdc-icon-button">dashboard</button>
                           <span>
                              <a class="mdc-icon-button material-icons-two-tone" href="{$xtfURL}search" target="_top">home</a>
                           </span>
                           <xsl:choose>
                              <xsl:when test="session:getData('queryURL')">
                                 <span>
                                    <a class="mdc-icon-button material-icons-two-tone" href="{session:getData('queryURL')}" target="_top">arrow_back</a>
                                 </span>
                              </xsl:when>
                              <xsl:otherwise>
                                 <!--<span class="notActive">Return to Search Results</span>-->
                              </xsl:otherwise>
                           </xsl:choose>
                        </section>
                        <section class="mdc-top-app-bar__section middle">
                           <form action="{$xtfURL}{$dynaxmlPath}" id="search-form" method="get" target="_top">
                              <div class="mdc-text-field mdc-text-field--outlined search-field">
                                 <input class="mdc-text-field__input" id="search-text-input" name="query" type="text">
                                    <div class="mdc-notched-outline">
                                       <div class="mdc-notched-outline__leading" />
                                       <div class="mdc-notched-outline__notch">
                                          <label class="mdc-floating-label" for="search-text-input">query…</label>
                                       </div>
                                       <div class="mdc-notched-outline__trailing" />
                                    </div>
                                 </input>
                              </div>
                              <input name="docId" type="hidden" value="{$docId}" />
                              <input name="chunk.id" type="hidden" value="{$chunk.id}" />
                           </form>
                           <button class="mdc-button mdc-button--outlined search-button" form="search-form" type="submit" value="Search">
                              <span class="mdc-button__label">Search</span>
                           </button>
                        </section>
                        <section class="mdc-top-app-bar__section mdc-top-app-bar__section--align-end" role="toolbar">
                           <a class="mdc-icon-button material-icons-two-tone">
                              <xsl:attribute name="href">javascript://</xsl:attribute>
                              <xsl:attribute name="onclick">
                                 <xsl:text>javascript:window.open('</xsl:text>
                                 <xsl:value-of select="$xtfURL" />
                                 <xsl:value-of select="$dynaxmlPath" />
                                 <xsl:text>?docId=</xsl:text>
                                 <xsl:value-of select="$docId" />
                                 <xsl:text>;doc.view=citation;chunk.id=</xsl:text>
                                 <xsl:value-of select="$chunk.id" />
                                 <xsl:text>','popup','width=800,height=400,resizable=yes,scrollbars=yes')</xsl:text>
                              </xsl:attribute> format_quote </a>
                           <a class="mdc-icon-button material-icons-two-tone" href="{$doc.path}&#038;doc.view=print;chunk.id={$chunk.id}" target="_top">print</a>
                           <a class="mdc-icon-button material-icons-two-tone" href="javascript://" onclick="javascript:window.open('/xtf/search?smode=getLang','popup','width=500,height=200,resizable=no,scrollbars=no')">language</a>
                           <a class="mdc-icon-button material-icons-two-tone settings">settings</a>
                           <!-- href="javascript://" onclick="javascript:window.open('/xtf/search?smode=getEdit','popup', 'width=500, height=580, scrollbars=no')"-->
                           <a class="mdc-icon-button material-icons-two-tone">
                              <xsl:attribute name="href">javascript://</xsl:attribute>
                              <xsl:attribute name="onclick">
                                 <xsl:text>javascript:window.open('</xsl:text>
                                 <xsl:value-of select="$xtfURL" />
                                 <xsl:value-of select="$dynaxmlPath" />
                                 <xsl:text>?docId=</xsl:text>
                                 <xsl:value-of select="$docId" />
                                 <xsl:text>;doc.view=help;</xsl:text>
                                 <xsl:text>','popup','width=800,height=400,resizable=yes,scrollbars=no')</xsl:text>
                              </xsl:attribute> help </a>
                        </section>
                     </div>
                  </header>
                  <script src="/xtf/style/dynaXML/docFormatter/common/tmg.js" />
               </body>
            </html>
         </xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <!-- ====================================================================== -->
   <!-- Help Template                                                      -->
   <!-- ====================================================================== -->
   <xsl:template name="help">
      <html lang="en" xml:lang="en">
         <head>
            <title> Help </title>
            <link href="{$css.path}bbar.css" rel="stylesheet" type="text/css" />
            <link href="icons/default/favicon.ico" rel="shortcut icon" />
         </head>
         <body>
            <xsl:copy-of select="$brand.header" />
            <div class="container">
               <h3>Help</h3>
               <div class="citation">
                  <ul>
                     <li>
                        <a href="http://tmg.huma-num.fr/sites/default/files/Guidelines_TMG_05072016_Fr.pdf" style="color:brown; text-decoration: none">User guidelines</a>
                     </li>
                     <li>
                        <a href="http://tmg.huma-num.fr/sites/default/files/Edition_TMG_15022016_DeFr_0.pdf" style="color:brown; text-decoration: none">Editing methodology</a>
                     </li>
                     <li>
                        <a href="http://tmg.huma-num.fr/sites/default/files/Encoding_TMG_15022016_DE.pdf" style="color:brown; text-decoration: none">Encoding methodology (TEI/MEI)</a>
                     </li>
                     <li>
                        <a href="mailto:christophe.guillotel@gmail.fr" style="color:brown; text-decoration: none">Comments? Questions?</a>
                     </li>
                  </ul>
                  <a>
                     <xsl:attribute name="href">javascript://</xsl:attribute>
                     <xsl:attribute name="onClick">
                        <xsl:text>javascript:window.close('popup')</xsl:text>
                     </xsl:attribute>
                     <span style="color:brown; text-decoration: none">Close this Window</span>
                  </a>
               </div>
            </div>
         </body>
      </html>
   </xsl:template>
   <!-- ====================================================================== -->
   <!-- Citation Template                                                      -->
   <!-- ====================================================================== -->
   <xsl:template name="citation">
      <html lang="en" xml:lang="en">
         <head>
            <title>
               <xsl:value-of select="$doc.title" />
            </title>
            <link href="{$css.path}bbar.css" rel="stylesheet" type="text/css" />
            <link href="icons/default/favicon.ico" rel="shortcut icon" />
         </head>
         <body>
            <xsl:copy-of select="$brand.header" />
            <div class="container">
               <h3>Citation</h3>
               <div class="citation">
                  <xsl:variable name="chunk" select="substring-after($http.URL, 'chunk.id=')" />
                  <xsl:variable name="chunkSec" select="replace(substring-after($chunk, 'div_'), '_', '.')" />
                  <p><xsl:value-of select="/*/*:meta/*:creator[1]" />, <xsl:value-of select="/*/*:meta/*:title[1]" />, <xsl:value-of select="/*/*:meta/*:year[1]" />, <xsl:value-of select="$chunkSec" />.<br /> [<xsl:value-of select="concat($xtfURL, $dynaxmlPath, '?docId=', $docId, ';chunk.id=', $chunk)" />]</p>
                  <a>
                     <xsl:attribute name="href">javascript://</xsl:attribute>
                     <xsl:attribute name="onClick">
                        <xsl:text>javascript:window.close('popup')</xsl:text>
                     </xsl:attribute>
                     <span class="down1">Close this Window</span>
                  </a>
               </div>
            </div>
         </body>
      </html>
   </xsl:template>
   <!-- ====================================================================== -->
   <!-- Robot Template                                                         -->
   <!-- ====================================================================== -->
   <xsl:template name="robot">
      <html>
         <head>
            <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
            <title>
               <xsl:value-of select="//xtf:meta/title[1]" />
            </title>
            <link href="icons/default/favicon.ico" rel="shortcut icon" />
         </head>
         <body>
            <div>
               <xsl:apply-templates mode="robot" select="//text()" />
            </div>
         </body>
      </html>
   </xsl:template>
   <xsl:template match="text()" mode="robot">
      <xsl:value-of select="." />
      <xsl:text> </xsl:text>
   </xsl:template>
</xsl:stylesheet>
