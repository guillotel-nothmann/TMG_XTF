<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xmlns:xtf="http://cdlib.org/xtf"
   xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:session="java:org.cdlib.xtf.xslt.Session"
   extension-element-prefixes="session" exclude-result-prefixes="#all">

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


   <!-- Import sheets -->
   <xsl:import href="../common/docFormatterCommon.xsl"/>
   <xsl:import href="parameter.xsl"/>
   <!--  <xsl:import href="../mei/meiVerovio.xsl"/>-->
   <xsl:param name="http.referer"/>



   <!-- ====================================================================== -->
   <!-- Heads                                                                  -->
   <!-- ====================================================================== -->

   <xsl:template match="*:head[not(ancestor::*:table)]">



      <xsl:variable name="type" select="parent::*/@type"/>
      <xsl:variable name="class">
         <xsl:choose>
            <xsl:when test="@rend">
               <xsl:value-of select="@rend"/>
            </xsl:when>
            <xsl:otherwise>normal</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:choose>
         <xsl:when test="$type = 'fmsec'">
            <h2 class="{$class}">
               <xsl:apply-templates/>
            </h2>
         </xsl:when>
         <xsl:when test="$type = 'volume'">
            <h1 class="{$class}">
               <xsl:if test="parent::*/@n">
                  <xsl:value-of select="parent::*/@n"/>
                  <xsl:text>. </xsl:text>
               </xsl:if>
               <xsl:apply-templates/>
            </h1>
         </xsl:when>
         <xsl:when test="$type = 'part'">
            <h1 class="{$class}">
               <xsl:if test="parent::*/@n">
                  <xsl:value-of select="parent::*/@n"/>
                  <xsl:text>. </xsl:text>
               </xsl:if>
               <xsl:apply-templates/>
            </h1>
         </xsl:when>
         <xsl:when test="$type = 'chapter'">
            <h2 class="{$class}">
               <xsl:if test="parent::*/@n">
                  <xsl:value-of select="parent::*/@n"/>
                  <xsl:text>. </xsl:text>
               </xsl:if>
               <xsl:apply-templates/>
            </h2>
         </xsl:when>
         <xsl:when test="$type = 'ss1'">
            <h3 class="{$class}">
               <xsl:if test="parent::*/@n">
                  <xsl:value-of select="parent::*/@n"/>
                  <xsl:text>. </xsl:text>
               </xsl:if>
               <xsl:apply-templates/>
            </h3>
         </xsl:when>
         <xsl:when test="$type = 'ss2'">
            <h3 class="{$class}">
               <xsl:apply-templates/>
            </h3>
         </xsl:when>
         <xsl:when test="$type = 'ss3'">
            <h3 class="{$class}">
               <xsl:apply-templates/>
            </h3>
         </xsl:when>
         <xsl:when test="$type = 'ss4'">
            <h4 class="{$class}">
               <xsl:apply-templates/>
            </h4>
         </xsl:when>
         <xsl:when test="$type = 'ss5'">
            <h4 class="{$class}">
               <xsl:apply-templates/>
            </h4>
         </xsl:when>
         <xsl:when test="$type = 'bmsec'">
            <h2 class="{$class}">
               <xsl:apply-templates/>
            </h2>
         </xsl:when>
         <xsl:when test="$type = 'appendix'">
            <h2 class="{$class}">
               <xsl:if test="parent::*/@n">
                  <xsl:value-of select="parent::*/@n"/>
                  <xsl:text>. </xsl:text>
               </xsl:if>
               <xsl:apply-templates/>
            </h2>
         </xsl:when>
         <xsl:when test="$type = 'endnotes'">
            <h3 class="{$class}">
               <xsl:apply-templates/>
            </h3>
         </xsl:when>
         <xsl:when test="$type = 'bibliography'">
            <h2 class="{$class}">
               <xsl:apply-templates/>
            </h2>
         </xsl:when>
         <xsl:when test="$type = 'glossary'">
            <h2 class="{$class}">
               <xsl:apply-templates/>
            </h2>
         </xsl:when>
         <xsl:when test="$type = 'index'">
            <h2 class="{$class}">
               <xsl:apply-templates/>
            </h2>
         </xsl:when>
         <xsl:when test="ancestor::*:lg or parent::*:list and not(ancestor::*:figure)">
            <h4>
               <xsl:apply-templates/>
            </h4>
         </xsl:when>
         <xsl:when test="parent::*:figure">
            <xsl:apply-templates/>
         </xsl:when>


         <xsl:otherwise>
            <xsl:choose>
               <xsl:when
                  test="ancestor::*[matches(local-name(), '^div')]/descendant::*:del//*:note/@type = 'marginalia' and $del = 'true'">
                  <!-- ancestor is div which has descendant note -->
                  <div class="pb_resize">
                     <xsl:call-template name="create_titleBG"/>
                  </div>
               </xsl:when>
               <xsl:when
                  test="ancestor::*[matches(local-name(), '^div')]/descendant::*:note[@type = 'marginalia' and not(ancestor::*:del)]">
                  <!-- ancestor is div which has descendant note -->
                  <div class="pb_resize">
                     <xsl:call-template name="create_titleBG"/>
                  </div>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:call-template name="create_titleBG"/>
               </xsl:otherwise>
            </xsl:choose>


         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <xsl:template name="create_titleBG">
      <p/>
      <table BORDER="0" BGCOLOR="#EEEEEE" width="100%">
         <TR>
            <TH>
               <h3 style="text-align:justify">
                  <span style="line-height:1.5em;">
                     <xsl:apply-templates/>
                  </span>
               </h3>
            </TH>
         </TR>
      </table>
      <p/>
   </xsl:template>



   <xsl:template match="*:title">
      <xsl:choose>
         <xsl:when test="@type = 'subbiblio'">
            <h4>
               <xsl:apply-templates/>
            </h4>
         </xsl:when>
         <xsl:when test="name(parent::node()[1]) = 'note' or name(parent::node()[1]) = 'item'">
            <h3>
               <xsl:apply-templates/>
            </h3>
         </xsl:when>
         <xsl:when test="ancestor::*:lg">
            <span style="text-align:justify; font-size:1.1em">
               <b>
                  <xsl:apply-templates/>
               </b>
            </span>
         </xsl:when>
         <xsl:when test="@type = 'sub'">
            <br/>
            <xsl:apply-templates/>
         </xsl:when>
         <xsl:when test="ancestor::*:figure">
            <br/>
            <span style="text-align:justify; line-height:1.4em; font-size: 1.00em">
               <xsl:if test="@n"><xsl:value-of select="@n"/>. </xsl:if>
               <xsl:apply-templates/>
            </span>
         </xsl:when>
         <xsl:when test="parent::*:bibl">
            <i>
               <xsl:value-of>, </xsl:value-of>
               <xsl:value-of select="."/>
            </i>
         </xsl:when>

         <xsl:otherwise>
            <xsl:apply-templates/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <xsl:template match="*:docAuthor">
      <h4>
         <xsl:apply-templates/>
      </h4>
   </xsl:template>

   <xsl:template match="*:docDate">
      <xsl:apply-templates/>
   </xsl:template>

   <xsl:template match="*:persName">
      <xsl:if test="ancestor::*:listPerson">
         <thead>
            <h3>
               <xsl:choose>
                  <xsl:when test="*:surname">
                     <xsl:value-of select="*:forename"/>

                     <xsl:value-of select="concat(' ', *:surname)"/>
                  </xsl:when>
                  <xsl:when test="*:name">
                     <xsl:value-of select="*:name[not(@type = 'other')]"/>
                  </xsl:when>
               </xsl:choose>
            </h3>
         </thead>


         <xsl:if test="*:name[not(@type = 'other')]">
            <xsl:call-template name="note-row">
               <xsl:with-param name="value_1">Name:</xsl:with-param>
               <xsl:with-param name="value_2">
                  <xsl:value-of select="*:name[not(@type = 'other')]"/>
               </xsl:with-param>
            </xsl:call-template>
         </xsl:if>

         <xsl:if test="*:name[@type = 'other']">
            <xsl:call-template name="note-row">
               <xsl:with-param name="value_1">Other Name(s):</xsl:with-param>
               <xsl:with-param name="value_2">
                  <xsl:value-of select="*:name[@type = 'other']"/>
               </xsl:with-param>
            </xsl:call-template>
         </xsl:if>

         <xsl:if test="*:surname">
            <xsl:call-template name="note-row">
               <xsl:with-param name="value_1">Surname:</xsl:with-param>
               <xsl:with-param name="value_2">
                  <xsl:value-of select="*:surname"/>
               </xsl:with-param>
            </xsl:call-template>
         </xsl:if>

         <xsl:if test="*:forename">
            <xsl:call-template name="note-row">
               <xsl:with-param name="value_1">Forename:</xsl:with-param>
               <xsl:with-param name="value_2">
                  <xsl:value-of select="*:forename"/>
               </xsl:with-param>
            </xsl:call-template>
         </xsl:if>
      </xsl:if>




   </xsl:template>
   <!-- ====================================================================== -->
   <!-- Verse                                                                  -->
   <!-- ====================================================================== -->

   <xsl:template match="*:lg">
      <div align="center" style="margin-top:1em; margin-bottom:1.5em">
         <table border="0" cellpadding="1" width="100%">
            <tr>

               <td>
                  <xsl:apply-templates/>
               </td>
            </tr>
         </table>
      </div>
   </xsl:template>

   <xsl:template match="*:l">
      <xsl:choose>
         <xsl:when test="parent::*:lg">
            <table border="0" cellpadding="1" width="100%">

               <tr>
                  <td width="30" align="left">
                     <xsl:choose>
                        <xsl:when test="@n">
                           <span class="run-head">
                              <xsl:value-of select="@n"/>
                           </span>
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:text> </xsl:text>
                        </xsl:otherwise>
                     </xsl:choose>
                  </td>
                  <td>
                     <xsl:choose>
                        <xsl:when
                           test="parent::*:lg[@type = 'couplet'] and (count(preceding-sibling::*:l) + 1) mod 2 = 0">

                           <p class="indent"
                              style="text-align:left; line-height:1.4em; font-size: 1.15em">
                              <xsl:apply-templates/>
                           </p>
                        </xsl:when>
                        <xsl:otherwise>
                           <span class="noindent"
                              style="text-align:left; line-height:1.4em; font-size: 1.15em">
                              <xsl:apply-templates/>
                           </span>
                        </xsl:otherwise>
                     </xsl:choose>


                  </td>
               </tr>
            </table>
         </xsl:when>
         <xsl:otherwise>
            <table border="1" width="100%">
               <xsl:if test="@n">
                  <span class="run-head">
                     <xsl:value-of select="@n"/>
                  </span>
               </xsl:if>
               <span class="noindent" style="text-align:left; line-height:1.4em; font-size: 1.15em">

                  <xsl:apply-templates/>
               </span>
               <br/>
            </table>
         </xsl:otherwise>
      </xsl:choose>

   </xsl:template>

   <xsl:template match="*:seg">
      <xsl:if test="position() > 1">
         <xsl:text>&#160;&#160;&#160;&#160;</xsl:text>
      </xsl:if>
      <xsl:apply-templates/>
      <br/>
   </xsl:template>

   <!-- ====================================================================== -->
   <!-- Speech                                                                 -->
   <!-- ====================================================================== -->

   <xsl:template match="*:sp">
      <xsl:apply-templates/>
      <br/>
   </xsl:template>

   <xsl:template match="*:speaker">
      <b>
         <xsl:apply-templates/>
      </b>
   </xsl:template>

   <xsl:template match="*:sp/*:p">
      <p class="noindent">
         <xsl:apply-templates/>
      </p>
   </xsl:template>

   <!-- ====================================================================== -->
   <!-- Lists                                                                  -->
   <!-- ====================================================================== -->

   <xsl:template match="*:list">
      <xsl:choose>
         <xsl:when test="ancestor::*:list or ancestor::*:title">
            <xsl:call-template name="list"/>
         </xsl:when>
         <xsl:otherwise>
            <span class="normal" style="text-align:justify; line-height:1.4em; font-size: 1.15em">
               <xsl:call-template name="list"/>
            </span>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>



   <xsl:template name="list">

      <xsl:choose>
         <xsl:when test="@type = 'gloss'">
            <dl>
               <xsl:apply-templates/>
            </dl>
         </xsl:when>
         <xsl:when test="@type = 'simple'">
            <ul class="nobull">
               <xsl:apply-templates/>
            </ul>
         </xsl:when>
         <xsl:when test="@type = 'ordered'">
            <xsl:choose>
               <xsl:when test="@rend = 'alpha'">
                  <ol class="alpha">
                     <xsl:apply-templates/>
                  </ol>
               </xsl:when>
               <xsl:when test="@rend = 'numeric'">
                  <ol>
                     <xsl:apply-templates/>
                  </ol>
               </xsl:when>

               <xsl:when test="@rend = 'roman'">
                  <ol type="I">
                     <xsl:apply-templates/>
                  </ol>
               </xsl:when>
               <xsl:otherwise>

                  <xsl:apply-templates/>

               </xsl:otherwise>
            </xsl:choose>
         </xsl:when>
         <xsl:when test="@type = 'unordered'">
            <ul>
               <xsl:apply-templates/>
            </ul>
         </xsl:when>
         <xsl:when test="@type = 'bulleted'">
            <xsl:choose>
               <xsl:when test="@rend = 'dash'">
                  <ul class="nobull">
                     <xsl:text>- </xsl:text>
                     <xsl:apply-templates/>
                  </ul>
               </xsl:when>
               <xsl:otherwise>
                  <ul>
                     <xsl:apply-templates/>
                  </ul>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:when>
         <xsl:when test="@type = 'bibliographic'">
            <ol>
               <xsl:apply-templates/>
            </ol>
         </xsl:when>
         <xsl:when test="@type = 'special'">
            <ul>
               <xsl:apply-templates/>
            </ul>
         </xsl:when>
         <xsl:when test="@type = 'index'">
            <xsl:apply-templates/>
         </xsl:when>
      </xsl:choose>
   </xsl:template>

   <xsl:template match="*:item">
      <xsl:choose>
         <xsl:when test="parent::*:list[@type = 'gloss']">
            <table>
               <thead>
                  <tr>
                     <xsl:apply-templates select="*:title"/>
                  </tr>
               </thead>
               <xsl:apply-templates select="*:ref[@type = 'ext']"/>
               <xsl:if test="*:ref[@type = 'int']">
                  <tr>
                     <td>
                        <b>Related entries:</b>
                     </td>
                     <td>
                        <xsl:apply-templates select="*:ref[@type = 'int']"/>
                     </td>
                  </tr>
               </xsl:if>
            </table>
         </xsl:when>
         <xsl:when test="parent::*:list[@type = 'index']">
            <!-- index in the source -->

            <table>
               <tr>
                  <td width="80%">

                     <xsl:apply-templates select="text()"/>
                  </td>
                  <td>
                     <xsl:apply-templates select="*:ref"/>
                  </td>
               </tr>
            </table>
         </xsl:when>
         <xsl:otherwise>
            <li style="margin-top:0.5em">
               <xsl:apply-templates/>
            </li>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <xsl:template match="*:label">
      <dt>
         <xsl:apply-templates/>
      </dt>
   </xsl:template>

   <xsl:template match="*:name">
      <xsl:apply-templates/>
   </xsl:template>

   <!-- ====================================================================== -->
   <!-- Notes                                                                  -->
   <!-- ====================================================================== -->
   <xsl:template match="*:note">

      <xsl:choose>
         <xsl:when test="@place = 'margin-left' or @place = 'margin-right'">
            <xsl:call-template name="margin"/>
         </xsl:when>
         <xsl:when test="@type = 'footnote'">
            <xsl:choose>
               <xsl:when test="//@xml:lang = 'la'">
                  <!-- critère header -->

                  <xsl:variable name="mainCorresp"
                     select="substring(//*[@xml:id = $chunk.id]/@corresp, 2)"/>

                  <xsl:choose>
                     <xsl:when test="ancestor::*/@xml:id = $chunk.id">
                        <xsl:element name="a">
                           <xsl:attribute name="style">
                              <xsl:text>text-decoration: none</xsl:text>
                           </xsl:attribute>
                           <xsl:attribute name="name">
                              <xsl:text>fna_main</xsl:text>
                              <xsl:number level="any" format="a"
                                 count="*:note[@type = 'footnote'][ancestor::*/@xml:id = $chunk.id]"
                              />
                           </xsl:attribute>

                           <xsl:attribute name="href">
                              <xsl:text>#fn_main</xsl:text>
                              <xsl:number level="any" format="a"
                                 count="*:note[@type = 'footnote'][ancestor::*/@xml:id = $chunk.id]"
                              />
                           </xsl:attribute>
                           <xsl:attribute name="title">
                              <xsl:value-of select="normalize-space(.)"/>
                           </xsl:attribute>
                           <span
                              style="font-size:9pt;vertical-align:super;color:brown; line-height:0em;">
                              <xsl:number level="any" format="a"
                                 count="*:note[@type = 'footnote'][ancestor::*/@xml:id = $chunk.id]"
                              />
                           </span>
                        </xsl:element>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:element name="a">
                           <xsl:attribute name="style">
                              <xsl:text>text-decoration: none</xsl:text>
                           </xsl:attribute>
                           <xsl:attribute name="name">
                              <xsl:text>fna_sec</xsl:text>
                              <xsl:number level="any"
                                 count="*:note[@type = 'footnote'][ancestor::*/@xml:id = $mainCorresp]"
                              />
                           </xsl:attribute>

                           <xsl:attribute name="href">
                              <xsl:text>#fn_sec</xsl:text>
                              <xsl:number level="any"
                                 count="*:note[@type = 'footnote'][ancestor::*/@xml:id = $mainCorresp]"
                              />
                           </xsl:attribute>
                           <xsl:attribute name="title">
                              <xsl:value-of select="normalize-space(.)"/>
                           </xsl:attribute>
                           <span
                              style="font-size:9pt;vertical-align:super;color:brown; line-height:0em;">
                              <xsl:number level="any"
                                 count="*:note[@type = 'footnote'][ancestor::*/@xml:id = $mainCorresp]"
                              />
                           </span>
                        </xsl:element>
                     </xsl:otherwise>
                  </xsl:choose>



               </xsl:when>

               <xsl:otherwise>
                  <xsl:element name="a">
                     <xsl:attribute name="style">
                        <xsl:text>text-decoration: none</xsl:text>
                     </xsl:attribute>
                     <xsl:attribute name="name">
                        <xsl:text>fna</xsl:text>
                        <xsl:number level="any" count="*:note[@type = 'footnote']"/>
                     </xsl:attribute>

                     <xsl:attribute name="href">
                        <xsl:text>#fn</xsl:text>
                        <xsl:number level="any" count="*:note[@type = 'footnote']"/>
                     </xsl:attribute>
                     <xsl:attribute name="title">
                        <xsl:value-of select="normalize-space(.)"/>
                     </xsl:attribute>
                     <span style="font-size:9pt;vertical-align:super;color:brown; line-height:0em;">
                        <xsl:number level="any" count="*:note[@type = 'footnote']"/>
                     </span>
                  </xsl:element>
               </xsl:otherwise>
            </xsl:choose>



         </xsl:when>
         <xsl:otherwise>
            <xsl:apply-templates/>
         </xsl:otherwise>
      </xsl:choose>



   </xsl:template>

   <xsl:template name="footnote">

      <xsl:for-each select="key('div-id', $chunk.id)//*:note[@type = 'footnote']">
         <div class="footnotes">


            <xsl:element name="a">
               <xsl:attribute name="name">
                  <xsl:text>fn</xsl:text>
                  <xsl:number level="any" count="*:note[@type = 'footnote']"/>
               </xsl:attribute>
               <a style="text-decoration: none">
                  <xsl:attribute name="href">
                     <xsl:text>#fna</xsl:text>
                     <xsl:number level="any" count="*:note[@type = 'footnote']"/>
                  </xsl:attribute>
                  <span style="font-size:0.6em;vertical-align:super;color:brown;">
                     <xsl:number level="any" count="*:note[@type = 'footnote']"/>
                     <xsl:text> </xsl:text>
                  </span>
               </a>
               <xsl:apply-templates/>
            </xsl:element>
         </div>
      </xsl:for-each>
   </xsl:template>

   <xsl:template name="margin">
      <xsl:choose>
         <xsl:when test="ancestor::*:titlePage">
            <span class="absolute-right_title">
               <xsl:apply-templates/>
            </span>

         </xsl:when>
         <xsl:otherwise>
            <span class="absolute-right">
               <xsl:apply-templates/>
            </span>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>


   <xsl:template name="note-row">
      <xsl:param name="value_1"/>
      <xsl:param name="value_2"/>
      <xsl:param name="value_3"/>
      <tr>
         <td>
            <b>
               <xsl:value-of select="$value_1"/>
            </b>
         </td>
         <td>
            <xsl:if test="$value_3 != ''"><xsl:value-of select="$value_3"/>, </xsl:if>
            <xsl:copy-of select="$value_2"/>
         </td>
      </tr>
   </xsl:template>

   <xsl:template match="*:person | *:personGrp">

      <table>
         <xsl:apply-templates select="*:persName"/>

         <xsl:if test="*:birth">
            <xsl:call-template name="note-row">
               <xsl:with-param name="value_1">Birth:</xsl:with-param>
               <xsl:with-param name="value_2">
                  <xsl:value-of select="*:birth/*:date"/>
               </xsl:with-param>
               <xsl:with-param name="value_3">
                  <xsl:value-of select="*:birth/*:placeName"/>
               </xsl:with-param>
            </xsl:call-template>
         </xsl:if>

         <xsl:if test="*:event/*:desc/*:date[@baptized]">
            <xsl:call-template name="note-row">
               <xsl:with-param name="value_1">Bapitzed:</xsl:with-param>
               <xsl:with-param name="value_2">
                  <xsl:value-of select="*:event/*:desc/*:date"/>
               </xsl:with-param>
               <xsl:with-param name="value_3">
                  <xsl:value-of select="*:event/*:desc/*:placeName"/>
               </xsl:with-param>
            </xsl:call-template>
         </xsl:if>

         <xsl:if test="*:floruit">

            <xsl:call-template name="note-row">
               <xsl:with-param name="value_1">Floruit:</xsl:with-param>
               <xsl:with-param name="value_2">
                  <xsl:for-each select="*:floruit">
                     <xsl:value-of select="*:date"/>
                     <xsl:value-of>, </xsl:value-of>
                     <xsl:value-of select="*:placeName"/>
                     <xsl:if test="not(*:placeName)">?</xsl:if>
                     <xsl:if test="position() != last()">; </xsl:if>
                  </xsl:for-each>
               </xsl:with-param>
            </xsl:call-template>
         </xsl:if>

         <xsl:if test="*:death">
            <xsl:call-template name="note-row">
               <xsl:with-param name="value_1">Death:</xsl:with-param>
               <xsl:with-param name="value_2">
                  <xsl:value-of select="*:death/*:date"/>
               </xsl:with-param>
               <xsl:with-param name="value_3">
                  <xsl:value-of select="*:death/*:placeName"/>
               </xsl:with-param>
            </xsl:call-template>
         </xsl:if>

         <xsl:if test="*:event/*:desc/*:date[@burried]">
            <xsl:call-template name="note-row">
               <xsl:with-param name="value_1">Burried:</xsl:with-param>
               <xsl:with-param name="value_2">
                  <xsl:value-of select="*:event/*:desc/*:date"/>
               </xsl:with-param>
               <xsl:with-param name="value_3">
                  <xsl:value-of select="*:event/*:desc/*:placeName"/>
               </xsl:with-param>
            </xsl:call-template>
         </xsl:if>
         <xsl:apply-templates select="*:persName/*:ref"/>

         <xsl:if test="*:persName/*:ref/@subtype = 'gnd'">
            <xsl:call-template name="note-row">
               <xsl:with-param name="value_1">GND:</xsl:with-param>
               <xsl:with-param name="value_2">
                  <a target="_blanc" style="color:brown; text-decoration: none">
                     <xsl:attribute name="href">
                        <xsl:value-of select="*:persName/*:ref[@subtype = 'gnd']/@target"/>
                     </xsl:attribute>
                     <xsl:value-of select="*:persName/*:ref[@subtype = 'gnd']/@cRef"/>
                  </a>
               </xsl:with-param>
            </xsl:call-template>
         </xsl:if>

         <xsl:if test="*:persName/*:ref/@subtype = 'grove'">
            <xsl:call-template name="note-row">
               <xsl:with-param name="value_1">Grove:</xsl:with-param>
               <xsl:with-param name="value_2">
                  <a target="_blanc" style="color:brown; text-decoration: none">
                     <xsl:attribute name="href">
                        <xsl:value-of select="*:persName/*:ref[@subtype = 'grove']/@target"/>
                     </xsl:attribute>
                     <xsl:value-of>➚</xsl:value-of>
                  </a>
               </xsl:with-param>
            </xsl:call-template>
         </xsl:if>

         <xsl:if test="*:persName/*:ref/@subtype = 'wikipedia'">
            <xsl:call-template name="note-row">
               <xsl:with-param name="value_1">Wikipedia:</xsl:with-param>
               <xsl:with-param name="value_2">
                  <a target="_blanc" style="color:brown; text-decoration: none">
                     <xsl:attribute name="href">
                        <xsl:value-of select="*:persName/*:ref[@subtype = 'wikipedia']/@target"/>
                     </xsl:attribute>
                     <xsl:value-of>➚</xsl:value-of>
                  </a>
               </xsl:with-param>
            </xsl:call-template>
         </xsl:if>
         <xsl:if test="*:note">
            <xsl:call-template name="note-row">
               <xsl:with-param name="value_1">Notes:</xsl:with-param>
               <xsl:with-param name="value_2">
                  <xsl:apply-templates select="*:note"/>
               </xsl:with-param>
            </xsl:call-template>
         </xsl:if>
         <tr>
            <td colspan="2">
               <xsl:apply-templates select="*:bibl"/>
            </td>
         </tr>
      </table>
   </xsl:template>

   <xsl:template match="*:place">
      <table>
         <head>
            <h3>
               <xsl:value-of select="*:placeName/text()"/>
            </h3>
         </head>
         <xsl:if test="*:placeName/*:placeName/@type = 'var'">
            <xsl:call-template name="note-row">
               <xsl:with-param name="value_1">Variant:</xsl:with-param>
               <xsl:with-param name="value_2">
                  <xsl:value-of select="*:placeName/*:placeName[@type = 'var']"/>
               </xsl:with-param>
            </xsl:call-template>
         </xsl:if>

         <xsl:if test="*:placeName/*:ref/@subtype = 'geonames'">
            <xsl:call-template name="note-row">
               <xsl:with-param name="value_1">Geonames:</xsl:with-param>
               <xsl:with-param name="value_2">
                  <a target="_blanc" style="color:brown; text-decoration: none">
                     <xsl:attribute name="href">
                        <xsl:value-of select="*:placeName/*:ref[@subtype = 'geonames']/@target"/>
                     </xsl:attribute>
                     <xsl:value-of select="*:placeName/*:ref[@subtype = 'geonames']/@cRef"/>
                  </a>
               </xsl:with-param>
            </xsl:call-template>
         </xsl:if>

         <xsl:if test="*:placeName/*:ref/@subtype = 'tgn'">
            <xsl:call-template name="note-row">
               <xsl:with-param name="value_1">TGN:</xsl:with-param>
               <xsl:with-param name="value_2">
                  <a target="_blanc" style="color:brown; text-decoration: none">
                     <xsl:attribute name="href">
                        <xsl:value-of select="*:placeName/*:ref[@subtype = 'tgn']/@target"/>
                     </xsl:attribute>
                     <xsl:value-of select="*:placeName/*:ref[@subtype = 'tgn']/@cRef"/>
                  </a>
               </xsl:with-param>
            </xsl:call-template>
         </xsl:if>

         <xsl:if test="*:placeName/*:ref/@subtype = 'oldmaps'">
            <xsl:call-template name="note-row">
               <xsl:with-param name="value_1">Oldmaps online:</xsl:with-param>
               <xsl:with-param name="value_2">
                  <a target="_blanc" style="color:brown; text-decoration: none">
                     <xsl:attribute name="href">
                        <xsl:value-of select="*:placeName/*:ref[@subtype = 'oldmaps']/@target"/>
                     </xsl:attribute>↗ </a>
               </xsl:with-param>
            </xsl:call-template>
         </xsl:if>

         <xsl:if test="*:placeName/*:ref/@subtype = 'wikipedia'">
            <xsl:call-template name="note-row">
               <xsl:with-param name="value_1">Wikipedia:</xsl:with-param>
               <xsl:with-param name="value_2">
                  <a target="_blanc" style="color:brown; text-decoration: none">
                     <xsl:attribute name="href">
                        <xsl:value-of select="*:placeName/*:ref[@subtype = 'wikipedia']/@target"/>
                     </xsl:attribute>↗ </a>
               </xsl:with-param>
            </xsl:call-template>
         </xsl:if>
      </table>
   </xsl:template>





   <!-- ====================================================================== -->
   <!-- Paragraphs                                                             -->
   <!-- ====================================================================== -->

   <xsl:template match="*:p[not(ancestor::note[@type = 'endnote' or @place = 'end'])]">
  
      
      <xsl:choose>
         <xsl:when test="child::*:figure | *:pb | *:table">
            <!-- paragraphe est sur une ou plusieurs pages ou englobant une figure ou un tableau-->
            <xsl:for-each-group select="node()"
               group-starting-with="*:figure | *:pb | *:table | *:quote">
               <xsl:if test="current-group()[self::*:pb]">
                  <xsl:apply-templates select="current-group()[self::*:pb]"/>
               </xsl:if>
               <xsl:if test="current-group()[self::*:figure]">
                  <xsl:apply-templates select="current-group()[self::*:figure]"/>
               </xsl:if>
               <xsl:if test="current-group()[self::*:table]">
                  <xsl:apply-templates select="current-group()[self::*:table]"/>
               </xsl:if>


               <xsl:choose>
                  <xsl:when test="position() = 1">
                     <p class="normal"
                        style="text-align:justify; line-height:1.4em; font-size: 1.15em">
                        
                     
                        
                        <xsl:apply-templates
                           select="current-group()[not(self::*:pb) and not(self::*:figure) and not(self::*:table)]"
                        />
                     </p>
                  </xsl:when>
                  <xsl:otherwise>
                     <p class="noindent"
                        style="text-align:justify; line-height:1.4em; font-size: 1.15em">
                        <xsl:apply-templates
                           select="current-group()[not(self::*:pb) and not(self::*:figure) and not(self::*:table)]"
                        />
                     </p>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:for-each-group>

         </xsl:when>

         <xsl:when test="child::*:list">
            <!-- le paragraphe doit être décomposé </p><list/>[...]</p> -->
            <xsl:variable name="p1">
               <p>
                  <xsl:copy-of
                     select="child::node()[not(preceding-sibling::*:list) and not(self::*:list)]"/>
               </p>
            </xsl:variable>
            <xsl:variable name="pb1">
               <xsl:copy-of select="*:list[1]"/>
            </xsl:variable>
            <xsl:variable name="p2">
               <p style="noindent">
                  <xsl:copy-of
                     select="child::node()[following-sibling::*:list and preceding-sibling::*:list]"
                  />
               </p>
            </xsl:variable>
            <xsl:variable name="pb2">
               <xsl:copy-of select="*:list[2]"/>
            </xsl:variable>
            <xsl:variable name="p3">
               <p style="noindent">
                  <xsl:copy-of
                     select="child::node()[not(following-sibling::*:list) and not(self::*:list)]"/>
               </p>
            </xsl:variable>

            <xsl:for-each select="$p1/*:p">
               <xsl:call-template name="p_create"/>
            </xsl:for-each>
            <xsl:for-each select="$pb1">
               <xsl:apply-templates/>
            </xsl:for-each>
            <xsl:for-each select="$p2/*:p">
               <xsl:call-template name="p_create"/>
            </xsl:for-each>
            <xsl:for-each select="$pb2">
               <xsl:apply-templates/>
            </xsl:for-each>
            <xsl:for-each select="$p3/*:p">
               <xsl:call-template name="p_create"/>
            </xsl:for-each>
         </xsl:when>
         <xsl:otherwise>
            <xsl:call-template name="p_create"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <xsl:template name="p_create">
      <xsl:choose>
         <xsl:when test="@rend = 'center'">
            <p class="center">
               <xsl:apply-templates/>
            </p>
         </xsl:when>
         <xsl:when test="@rend = 'centerH4'">
            <h4>
               <p class="center">

                  <xsl:apply-templates/>
               </p>
            </h4>
         </xsl:when>
         <xsl:when test="parent::td">
            <p>
               <xsl:apply-templates/>
            </p>
         </xsl:when>
         <xsl:when test="@rend = 'hang'">
            <p class="hang">
               <xsl:apply-templates/>
            </p>
         </xsl:when>
         <xsl:when test="@rend = 'indent'">
            <p class="indent">
               <xsl:apply-templates/>
            </p>
         </xsl:when>
         <xsl:when test="@rend = 'noindent'">
            <p class="noindent" style="text-align:justify; line-height:1.4em; font-size: 1.15em">
               <xsl:apply-templates/>
            </p>
         </xsl:when>
         <xsl:when test="@style = 'noindent'">
            <!-- employé pour les $ sur deux pages -->
            <p class="noindent" style="text-align:justify; line-height:1.4em; font-size: 1.15em">
               <xsl:apply-templates/>
            </p>
         </xsl:when>
         <xsl:when test="child::*:c/@rend='drop_capital'">
            <p class="noindent" style="text-align:justify; line-height:1.4em; font-size: 1.15em">
               <xsl:apply-templates/>
            </p>
         </xsl:when>
         
         
         <xsl:otherwise>
            <p class="normal" style="text-align:justify; line-height:1.4em; font-size: 1.15em">
               <xsl:apply-templates/>
            </p>
         </xsl:otherwise>
      </xsl:choose>

   </xsl:template>




   <!-- ======================================================================-->
   <!-- Other Text Blocks                                                      -->
   <!-- ====================================================================== -->

   <xsl:template match="*:epigraph">
      <blockquote>
         <xsl:apply-templates/>
      </blockquote>
      <br/>
   </xsl:template>

   <xsl:template match="*:epigraph/*:bibl">
      <p class="right">
         <xsl:apply-templates/>
      </p>
   </xsl:template>

   <xsl:template match="*:byline">
      <p class="right">
         <xsl:apply-templates/>
      </p>
   </xsl:template>

   <xsl:template match="*:cit">
      <xsl:apply-templates/>
   </xsl:template>

   <xsl:template match="*:cit/*:bibl">
      <p class="right">
         <xsl:apply-templates/>
      </p>
   </xsl:template>

   <xsl:template match="*:quote">
      <xsl:choose>
         <!-- cas particulier d'une citation qui commence au milieu d'un paragraphe et se poursuit d'une page à l'autre -->
         <xsl:when test="child::*:pb and not(descendant::*:p)">
            <!-- and descendant::*:p -->
            <xsl:variable name="q1">
               <quote type="{@type}" corresp="{@corresp}" subtype="q1">
                  <xsl:copy-of
                     select="child::node()[not(preceding-sibling::*:pb) and not(self::*:pb)]"/>
               </quote>
            </xsl:variable>
            <xsl:variable name="pb1">
               <xsl:copy-of select="*:pb[1]"/>
            </xsl:variable>
            <xsl:variable name="q2">
               <quote type="{@type}" corresp="{@corresp}" subtype="q2">
                  <xsl:copy-of
                     select="child::node()[not(following-sibling::*:pb) and not(self::*:pb)]"/>
               </quote>
            </xsl:variable>
            <xsl:for-each select="$q1/*:quote">
               <xsl:call-template name="q_create"/>
            </xsl:for-each>
            <xsl:for-each select="$pb1">
               <xsl:apply-templates/>
            </xsl:for-each>
            <xsl:for-each select="$q2/*:quote">
               <div class="noindent"
                  style="text-align:justify; line-height:1.4em; font-size: 1.15em">
                  <xsl:call-template name="q_create"/>
               </div>
            </xsl:for-each>
         </xsl:when>
         <xsl:otherwise>
            <xsl:call-template name="q_create"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>



   <xsl:template name="q_create">
      <xsl:variable name="corresp" select="substring(@corresp, 2)"/>
      <xsl:if test="not($anchor.id = '0')">
         <xsl:if
            test="$anchor.id = concat(@corresp, count(preceding::*:quote[@corresp = $corresp]) + 1)">
            <!-- ancre associée au changement de section -->
            <a id="X"/>
         </xsl:if>
         <a>
            <xsl:attribute name="id">
               <!-- ancres internes aux sections -->
               <xsl:value-of
                  select="concat(@corresp, count(preceding::*:quote[@corresp = $corresp]) + 1)"/>
            </xsl:attribute>
         </a>
      </xsl:if>

      <xsl:if test="not(@subtype = 'q2')">
         <a style="color:brown; text-decoration: none">
            <xsl:attribute name="href">javascript://</xsl:attribute>
            <xsl:attribute name="onclick">
               <xsl:text>javascript:window.open('</xsl:text><xsl:value-of select="$doc.path"
                  />&#038;doc.view=popup&#038;chunk.id=<xsl:value-of select="$corresp"
               /><xsl:text>','popup','width=600, height=300, resizable=yes, scrollbars=yes').focus();</xsl:text>
            </xsl:attribute>
            <img src="{concat ($icon.path, @type,'r', '.png')}" border="0" height="17"/>
         </a>
      </xsl:if>
      <xsl:apply-templates/>
      <xsl:if test="not(@subtype = 'q1')">
         <a style="color:brown; text-decoration: none">
            <xsl:attribute name="href">javascript://</xsl:attribute>
            <xsl:attribute name="onclick">
               <xsl:text>javascript:window.open('</xsl:text><xsl:value-of select="$doc.path"
                  />&#038;doc.view=popup&#038;chunk.id=<xsl:value-of select="$corresp"
               /><xsl:text>','popup','width=600, height=300, resizable=yes,scrollbars=yes').focus();</xsl:text>
            </xsl:attribute>
            <img src="{concat ($icon.path, @type,'l', '.png')}" border="0" height="17"/>
         </a>
      </xsl:if>
   </xsl:template>

   <xsl:template match="*:q">
      <blockquote>
         <xsl:apply-templates/>
      </blockquote>
   </xsl:template>

   <xsl:template match="*:date">
      <xsl:choose>
         <xsl:when test="parent::*:bibl">
            <xsl:value-of>, </xsl:value-of>
            <xsl:value-of select="."/>
            <xsl:value-of>.</xsl:value-of>
         </xsl:when>
         <xsl:otherwise>
            <xsl:apply-templates/>
         </xsl:otherwise>
      </xsl:choose>


   </xsl:template>

   <xsl:template match="*:foreign">
      <xsl:choose>
         <xsl:when test="@xml:lang = 'gr' and //*:normalization//*:item/@n = 'greek'">
            <xsl:apply-templates/>
         </xsl:when>
         <xsl:when test="@xml:lang = 'gr' and not(//*:normalization//*:item/@n = 'greek')">
            <xsl:value-of>[greek text]</xsl:value-of>
         </xsl:when>
         <xsl:otherwise>
            <i>
               <xsl:apply-templates/>
            </i>
         </xsl:otherwise>
      </xsl:choose>


   </xsl:template>

   <xsl:template match="*:fw">
      <div style="text-align:center; line-height:2.5em; font-size: 1.0em; color: grey">
         <xsl:apply-templates/>
      </div>
    
   </xsl:template>

   <xsl:template match="*:g">

      <xsl:variable name="ref" select="substring(@ref, 2)"/>
      <xsl:variable name="alt">[<xsl:value-of
            select="//*:charDecl/*:glyph[@xml:id = $ref]/*:glyphName"/>]</xsl:variable>
      <xsl:variable name="img_src"
         select="concat($c.path, //*:charDecl/*:glyph[@xml:id = $ref]/*:figure/*:graphic/@url)"/>
      <img src="{$img_src}" alt="{$alt}" height="17"/>
   </xsl:template>

   <xsl:template match="*:address">
      <xsl:apply-templates/>
   </xsl:template>

   <xsl:template match="*:addrLine">
      <xsl:apply-templates/>
      <br/>
   </xsl:template>

   <xsl:template match="*:ab">
      <p class="normal" style="text-align:justify; line-height:1.4em; font-size: 1.15em">
         <xsl:choose>
            <xsl:when test="@type = 'link'">
               <a style="color:brown; text-decoration: none">
                  <xsl:attribute name="href">
                     <xsl:value-of select="child::*:link/@facs"/>
                  </xsl:attribute>
                  <xsl:value-of select="text()"/>
               </a>
            </xsl:when>
            <xsl:when test="child::*:title[@type = 'main']">
               <h4>
                  <xsl:apply-templates select="child::*:title[@type = 'main']"/>
                  <br/>
                  <xsl:apply-templates select="child::*:title[@type = 'sub']"/>
               </h4>
            </xsl:when>
            <xsl:when test="child::*:title[not(@type)]">
               <h4>
                  <xsl:apply-templates select="child::*:title"/>
               </h4>
            </xsl:when>
            <xsl:otherwise>
               <xsl:apply-templates/>
            </xsl:otherwise>
         </xsl:choose>
      </p>
   </xsl:template>

   <xsl:template match="*:egXML">
      <xsl:variable name="nodestring">
         <pre><xsl:apply-templates select="." mode="serialize"/></pre>
      </xsl:variable>
      <span class="CodeEx">
         <table BORDER="0" BGCOLOR="#EEEEEE" width="100%" cellpadding="15%">
            <tr>
               <td>
                  <xsl:copy-of select="$nodestring"/>
               </td>
            </tr>
         </table>
      </span>
   </xsl:template>

   <xsl:template match="*" mode="serialize">
      <xsl:if test="not(name() = 'egXML')">
         <span class="node">
            <xsl:text>&lt;</xsl:text>
            <xsl:value-of select="name()"/>
         </span>
         <xsl:for-each select="@*">
            <xsl:text> </xsl:text>
            <span class="attribName">
               <xsl:value-of select="name()"/>
            </span>
            <span class="attribVal">
               <xsl:text>=&quot;</xsl:text>
               <xsl:value-of select="."/>
               <xsl:text>&quot;</xsl:text>
            </span>
         </xsl:for-each>
         <span class="node">
            <xsl:text>&gt;</xsl:text>
         </span>
      </xsl:if>
      <xsl:apply-templates mode="serialize"/>
      <xsl:if test="not(name() = 'egXML')">
         <span class="node">
            <xsl:text>&lt;/</xsl:text>
            <xsl:value-of select="name()"/>
            <xsl:text>&gt;</xsl:text>
         </span>
      </xsl:if>
   </xsl:template>

   <xsl:template match="text()" mode="serialize">
      <xsl:value-of select="."/>
   </xsl:template>



   <!-- ====================================================================== -->
   <!-- Bibliographies                                                         -->
   <!-- ====================================================================== -->
   <xsl:template match="*:biblFull">
      <xsl:value-of select="*:titleStmt/*:author/*:forename"/>
      <span style="font-variant:small-caps">
         <xsl:value-of select="concat(' ', *:titleStmt/*:author/*:surname)"/>
      </span>
      <i>
         <xsl:value-of select="concat(', ', *:titleStmt/*:title)"/>
      </i>
      <xsl:value-of
         select="concat(', ', *:publicationStmt/*:pubPlace, ': ', *:publicationStmt/*:publisher, ', ', *:publicationStmt/*:date, '. ')"/>
      <a>
         <xsl:attribute name="href">javascript://</xsl:attribute>
         <xsl:attribute name="onclick">
            <xsl:text>javascript:window.open('</xsl:text>
            <xsl:value-of select="*:sourceDesc/*:p/*:link/@facs"/>
            <xsl:text>','popup','location=no, width=600,height=600,resizable=yes,scrollbars=yes')</xsl:text>
         </xsl:attribute>
         <xsl:value-of select="*:sourceDesc/*:p"/>
      </a>
   </xsl:template>

   <xsl:template match="*:anchor">


      <xsl:choose>
         <xsl:when test="ancestor::*/@xml:id = $chunk.id">
            <a name="{@xml:id}" href="{@corresp}" style="text-decoration: none">
               <span style="font-size:10pt;color:grey; line-height:0em;">
                  <xsl:number level="any" count="*:anchor[ancestor::*/@xml:id = $chunk.id]"/>
                  <xsl:text>&#160;</xsl:text>
               </span>
            </a>
         </xsl:when>
         <xsl:otherwise>
            <xsl:variable name="mainCorresp"
               select="substring(//*[@xml:id = $chunk.id]/@corresp, 2)"/>


            <a name="{@xml:id}" href="{@corresp}" style="text-decoration: none">
               <span style="font-size:10pt;color:grey; line-height:0em;">
                  <xsl:number level="any" count="*:anchor[ancestor::*/@xml:id = $mainCorresp]"/>
                  <xsl:text>&#160;</xsl:text>
               </span>
            </a>


         </xsl:otherwise>
      </xsl:choose>





   </xsl:template>

   <xsl:template match="*:author">
      <xsl:choose>
         <xsl:when test="*:forename">
            <xsl:value-of select="*:forename"/>
            <span style="font-variant:small-caps">
               <xsl:value-of select="concat(' ', *:surname)"/>
            </span>
         </xsl:when>
         <xsl:otherwise>
            <span style="font-variant:small-caps">
               <xsl:value-of select="*:name"/>
            </span>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <xsl:template match="*:pubPlace">
      <xsl:choose>
         <xsl:when test="parent::*:bibl">
            <xsl:value-of>, </xsl:value-of>
            <xsl:value-of select="."/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:apply-templates/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <xsl:template match="*:publisher">
      <xsl:choose>
         <xsl:when test="parent::*:bibl">
            <xsl:value-of>: </xsl:value-of>
            <xsl:value-of select="."/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:apply-templates/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>



   <xsl:template match="*:bibl">
      <p align="justify">
         <xsl:choose>
            <xsl:when test="@type = 'book' or exists(@type) = false()">
               <xsl:if test="*:author">
                  <xsl:apply-templates select="*:author"/>
               </xsl:if>
               <xsl:if test="*:title">
                  <xsl:apply-templates select="*:title"/>
               </xsl:if>
               <xsl:if test="*:pubPlace">
                  <xsl:apply-templates select="*:pubPlace"/>
               </xsl:if>
               <xsl:if test="*:publisher">
                  <xsl:apply-templates select="*:publisher"/>
               </xsl:if>
               <xsl:if test="*:date">
                  <xsl:apply-templates select="*:date"/>
               </xsl:if>
               <xsl:if test="*:link">
                  <xsl:text> Online: </xsl:text>
                  <xsl:call-template name="createLink">
                     <xsl:with-param name="link" select="*:link/@facs"/>
                     <xsl:with-param name="ident" select="*:ident"/>
                  </xsl:call-template>
               </xsl:if>
               <xsl:if test="*:note">
                  <p>
                     <xsl:apply-templates select="*:note"/>
                  </p>
               </xsl:if>
            </xsl:when>

            <xsl:when test="@type = 'Oarticle'">
               <xsl:if test="*:author">
                  <xsl:apply-templates select="*:author"/>
               </xsl:if>
               <xsl:value-of select="concat(', &quot;', *:title[@type = 'sub'], '&quot;')"/>
               <i>
                  <xsl:value-of select="concat(', ', *:title[@type = 'main'], '. ')"/>
               </i>
               <xsl:if test="*:link">
                  <xsl:text> Online: </xsl:text>
                  <xsl:call-template name="createLink">
                     <xsl:with-param name="link" select="*:link/@facs"/>
                     <xsl:with-param name="ident" select="*:ident"/>
                  </xsl:call-template>
               </xsl:if>
            </xsl:when>

            <xsl:when test="@type = 'part'">
               <xsl:if test="*:author">
                  <xsl:apply-templates select="*:author"/>
               </xsl:if>
               <xsl:value-of select="concat(', &quot;', *:title[@type = 'part'], '&quot;')"/>
               <i>
                  <xsl:value-of select="concat(', ', *:title[@type = 'main'])"/>
               </i>
               <xsl:if test="*:pubPlace">
                  <xsl:apply-templates select="*:pubPlace"/>
               </xsl:if>
               <xsl:if test="*:publisher">
                  <xsl:apply-templates select="*:publisher"/>
               </xsl:if>
               <xsl:if test="*:date">
                  <xsl:apply-templates select="*:date"/>
               </xsl:if>
               <xsl:if test="*:link">
                  <xsl:text> Online: </xsl:text>
                  <xsl:call-template name="createLink">
                     <xsl:with-param name="link" select="*:link/@facs"/>
                     <xsl:with-param name="ident" select="*:ident"/>
                  </xsl:call-template>
               </xsl:if>
            </xsl:when>

            <xsl:when test="@type = 'Omisc'">
               <xsl:if test="*:author">
                  <xsl:apply-templates select="*:author"/>
               </xsl:if>
               <i>
                  <xsl:value-of select="concat(*:title, '. ')"/>
               </i>
               <xsl:if test="*:link">
                  <xsl:text> Online: </xsl:text>
                  <xsl:call-template name="createLink">
                     <xsl:with-param name="link" select="*:link/@facs"/>
                     <xsl:with-param name="ident" select="*:ident"/>
                  </xsl:call-template>
               </xsl:if>
            </xsl:when>

            <xsl:when test="@type = 'X'">
               <xsl:if test="*:note/*:link">
                  <a style="color:brown; text-decoration: none">
                     <xsl:attribute name="href">javascript://</xsl:attribute>
                     <xsl:attribute name="onclick">
                        <xsl:text>javascript:window.open('</xsl:text>
                        <xsl:value-of select="*:note/*:link/@facs"/>
                        <xsl:text>','popup','location=yes, width=600,height=600,resizable=yes,scrollbars=yes')</xsl:text>
                     </xsl:attribute>

                     <xsl:value-of select="*:note/*:ident"/>
                  </a>
               </xsl:if>
            </xsl:when>
         </xsl:choose>
      </p>
   </xsl:template>





   <xsl:template match="*:biblScope">
      <xsl:choose>
         <xsl:when test="parent::*/*:author/*:forename">
            <xsl:value-of select="parent::*/*:author/*:forename"/>
            <span style="font-variant:small-caps">
               <xsl:value-of select="concat(' ', parent::*/*:author/*:surname)"/>
            </span>
            <xsl:value-of>, </xsl:value-of>
         </xsl:when>
         <xsl:when test="parent::*/*:author/*:name">
            <span style="font-variant:small-caps">
               <xsl:value-of select="parent::*/*:author/*:name"/>
            </span>
            <xsl:value-of>, </xsl:value-of>
         </xsl:when>
         <xsl:otherwise/>
      </xsl:choose>


      <xsl:if test="parent::*/*:title[@type = 'part']">
         <xsl:value-of select="concat('&quot;', parent::*/*:title[@type = 'part'], '&quot;, ')"/>
      </xsl:if>
      <i>
         <xsl:choose>
            <xsl:when test="parent::*/*:title[@type = 'main']">
               <xsl:value-of select="parent::*/*:title[@type = 'main']"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="parent::*/*:title"/>
            </xsl:otherwise>
         </xsl:choose>
      </i>
      <xsl:choose>
         <xsl:when test="parent::*/*:pubPlace">
            <xsl:value-of
               select="concat(', ', parent::*/*:pubPlace, ': ', parent::*/*:publisher, ', ', parent::*/*:date, ', ')"
            />
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of>. </xsl:value-of>
         </xsl:otherwise>
      </xsl:choose>

      <xsl:choose>
         <xsl:when test="@type = 'pp'">
            <xsl:value-of select="concat('S. ', text()[1], '. ')"/>
         </xsl:when>
         <xsl:when test="@type = 'fol'">
            <xsl:value-of select="concat('Fol. ', text()[1], '. ')"/>
         </xsl:when>
         <xsl:when test="@type = 'lib'">
            <xsl:value-of select="concat('Lib. ', text()[1], '. ')"/>
         </xsl:when>
         <xsl:when test="@type = 'cap'">
            <xsl:value-of select="concat('Kap. ', text()[1], '. ')"/>
         </xsl:when>
         <xsl:when test="@type = 'num'">
            <xsl:value-of select="concat('Num. ', text()[1], '. ')"/>
         </xsl:when>
      </xsl:choose>
      <xsl:if test="*:note">
         <div style="margin-top:1.5em;">
            <xsl:apply-templates select="child::*:note"/>

         </div>
      </xsl:if>
      <xsl:if test="*:title">
         <xsl:value-of select="*:title"/>
         <text>. </text>
      </xsl:if>
      <xsl:if test="*:link">
         <a style="color:brown; text-decoration: none">
            <xsl:attribute name="href">javascript://</xsl:attribute>
            <xsl:attribute name="onclick">
               <xsl:text>javascript:window.open('</xsl:text>
               <xsl:value-of select="*:link/@facs"/>
               <xsl:text>','popup','location=no, width=600, height=600, resizable=yes, scrollbars=yes')</xsl:text>
            </xsl:attribute>
            <xsl:value-of select="*:ident"/>
         </a>
      </xsl:if>
      <xsl:if test="*:ref">
         <xsl:apply-templates select="*:ref"/>
      </xsl:if>
      <xsl:if test="*:certainty/@locus = 'location'">
         <p>
            <xsl:text>Das Zitat ist nicht eindeutig identifizierbar.</xsl:text>
         </p>
      </xsl:if>
   </xsl:template>

   <!-- ====================================================================== -->
   <!-- Formatting                                                             -->
   <!-- ====================================================================== -->

   <xsl:template match="*:hi">
      <xsl:choose>
         <xsl:when test="@rend = 'bold'">
            <b>
               <xsl:apply-templates/>
            </b>
         </xsl:when>
         <xsl:when test="@rend = 'italic'">
            <i>
               <xsl:apply-templates/>
            </i>
         </xsl:when>
         <xsl:when test="@rend = 'mono'">
            <code>
               <xsl:apply-templates/>
            </code>
         </xsl:when>
         <xsl:when test="@rend = 'roman'">
            <span class="normal">
               <xsl:apply-templates/>
            </span>
         </xsl:when>
         <xsl:when test="@rend = 'smallcaps'">
            <span class="sc">
               <xsl:apply-templates/>
            </span>
         </xsl:when>
         <xsl:when test="@rend = 'sub' or @rend = 'subscript'">
            <sub>
               <xsl:apply-templates/>
            </sub>
         </xsl:when>
         <xsl:when test="@rend = 'sup' or @rend = 'superscript'">
            <sup>
               <xsl:apply-templates/>
            </sup>
         </xsl:when>
         <xsl:when test="@rend = 'underline'">
            <u>
               <xsl:apply-templates/>
            </u>
         </xsl:when>
         <xsl:when test="@rend = 'fr'">
            <xsl:apply-templates/>
         </xsl:when>
         <xsl:otherwise>
            <i>
               <xsl:apply-templates/>
            </i>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <xsl:template match="*:lb">
      <!--  -->

      <xsl:if test="not(ancestor::*:list) and $lb = 'true'">
         <br/>
      </xsl:if>
   </xsl:template>

   <!-- ====================================================================== -->
   <!-- References                                                             -->
   <!-- ====================================================================== -->

   <xsl:template match="*:ref">


      <!-- variable -->
      <xsl:variable name="target" select="substring(@target, 2)"/>

      <!--<xsl:if test=" not($anchor.id='0')">
         <xsl:if test="@target=$target">
         
         <xsl:if test="$anchor.id=concat(@target,count(preceding:: *:ref[@target = $target])+1)">
         <a id="X"/>
         </xsl:if>
         </xsl:if>
         </xsl:if>-->
      <xsl:choose>

         <xsl:when test="@type = 'ext'">

            <a style="color:brown; text-decoration: none" href="{@target}" target="_blank">
               <xsl:apply-templates/>
            </a>

         </xsl:when>

         <xsl:when test="@type = 'int'">



            <xsl:choose>
               <xsl:when test="@subtype = 'pb'">

                  <xsl:variable name="target" select="substring(@target, 2)"/>
                  <xsl:variable name="target"
                     select="(//*[matches(name(), '^div')][descendant::*:pb/@xml:id = $target]/@xml:id)[last()]"/>
                  <a style="color:brown; text-decoration: none"
                     href="{$doc.path};&#038;chunk.id={$target};toc.id={$target};anchor.id={substring(@target, 2)}"
                     target="_top">
                     <xsl:apply-templates/>
                  </a>
               </xsl:when>

               <xsl:otherwise>
                  <xsl:variable name="target" select="substring(@target, 2)"/>
                  <a style="color:brown; text-decoration: none"
                     href="{$doc.path};&#038;chunk.id={$target};toc.id={$target}" target="_top">
                     <xsl:apply-templates/>
                  </a>
               </xsl:otherwise>
            </xsl:choose>





            <!-- <xsl:choose>
               <xsl:when test="$internal='true'">
               <xsl:choose>
               <xsl:when test="ancestor::*:ref[@type='work'] and $works='true'">
               <!-\- le lien 'work', l'emporte sur le lien 'int' -\->
               <xsl:apply-templates/> 
               </xsl:when>
               <xsl:otherwise>
               <a style="color:brown; text-decoration: none"
               href="{$doc.path};&#038;chunk.id={$target};toc.id={$target}"
               target="_top">
               <xsl:apply-templates/>
               </a>
               </xsl:otherwise>
               </xsl:choose>
               </xsl:when>
               <xsl:otherwise>
               <xsl:apply-templates/>
               </xsl:otherwise>
               </xsl:choose>-->
         </xsl:when>
      </xsl:choose>
   </xsl:template>

   <xsl:template match="*:rs">
      <xsl:variable name="target" select="substring(@ref, 2)"/>
      <xsl:if test="not($anchor.id = '0')">
         <xsl:if test="@target = $target">
            <xsl:if
               test="$anchor.id = concat(@target, count(preceding::*:ref[@target = $target]) + 1)">
               <a id="X"/>
            </xsl:if>
         </xsl:if>
      </xsl:if>
      <xsl:choose>
         <xsl:when
            test="@type = 'person' and $names = 'true' or @type = 'personGrp' and $names = 'true' or @type = 'work' and $works = 'true' or @type = 'place' and $places = 'true' or @type = 'thesaurus' and $thesaurus = 'true'">
            <xsl:choose>
               <xsl:when test="ancestor::*:ref[@type = 'work'] and $works = 'true'">
                  <!-- le lien 'work', l'emporte sur le lien 'thesaurus', 'person', 'place' -->
                  <xsl:apply-templates/>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:call-template name="createPopupLink">
                     <xsl:with-param name="pTarget" select="$target"/>
                  </xsl:call-template>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:when>
         <xsl:otherwise>
            <xsl:apply-templates/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <xsl:template name="createLink">
      <xsl:param name="link"/>
      <xsl:param name="ident"/>

      <a style="color:brown; text-decoration: none">
         <xsl:attribute name="target">_new</xsl:attribute>
         <xsl:attribute name="href" select="$link"/>
         <xsl:value-of select="$ident"/>
      </a>
   </xsl:template>

   <xsl:template name="createPopupLink">
      <xsl:param name="pTarget"/>
      <xsl:param name="pTitle"/>
      <a style="color:brown; text-decoration: none">
         <xsl:attribute name="href">javascript://</xsl:attribute>
         <xsl:attribute name="onclick">
            <xsl:text>javascript:window.open('</xsl:text><xsl:value-of select="$xtfURL"
               />view?docId=<xsl:value-of select="$indexS.path"
               />index.xml&#038;doc.view=popup&#038;chunk.id=<xsl:value-of select="$pTarget"
            /><xsl:text>','popup','width=600, height=300, resizable=yes,scrollbars=yes').focus();</xsl:text>
         </xsl:attribute>
         <xsl:apply-templates/>
         <xsl:value-of select="$pTitle"/>
         <xsl:if test="empty(node()) = true() and @rend = 'true'">
            <img src="{concat ($icon.path,'ref.png')}" border="0"/>
         </xsl:if>
      </a>
   </xsl:template>

   <xsl:template name="createTranscriptionPopup">
      <xsl:param name="pTarget"/>
      <xsl:param name="pTitle"/>
      <a>
         <xsl:attribute name="href">javascript://</xsl:attribute>
         <xsl:attribute name="onclick">
            <xsl:text>javascript:window.open('</xsl:text>
            <xsl:value-of select="concat($figure.path, @url)"/>
            <xsl:text>','popup','location=no, width=600,height=100,resizable=yes,scrollbars=yes')</xsl:text>
         </xsl:attribute>
         <img src="{$icon.path}xml.png" width="25" height="25" border="0" alt="MEI"/>
      </a>
   </xsl:template>



   <!-- ====================================================================== -->
   <!-- Edition                                                                -->
   <!-- ====================================================================== -->


   <xsl:template match="*:choice">
      <xsl:choose>
         <!-- une alternative "choice" correspond à un hit  -->
         <xsl:when test="ancestor::*:choice[@xtf:hitCount] and not(descendant::xtf:term)">
            <span class="hit">
               <xsl:if test="@n = '1' or @n = '4'">
                  <xsl:call-template name="choice_1"/>
               </xsl:if>
               <xsl:if test="@n = '2'">
                  <xsl:call-template name="choice_2"/>
               </xsl:if>
               <xsl:if test="@n = '3'">
                  <xsl:apply-templates/>
               </xsl:if>
               <xsl:if test="@n = '4'">
                  <xsl:call-template name="choice_1"/>
               </xsl:if>
            </span>
         </xsl:when>
         <xsl:otherwise>
            <xsl:if test="@n = '1'">
               <xsl:call-template name="choice_1"/>
            </xsl:if>
            <xsl:if test="@n = '2'">
               <xsl:call-template name="choice_2"/>
            </xsl:if>
            <xsl:if test="@n = '3'">
               <!-- majuscules après incise majeure? -->
               <xsl:call-template name="choice_1"/>
            </xsl:if>
            <xsl:if test="@n = '4'">
               <xsl:call-template name="choice_1"/>
            </xsl:if>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <xsl:template name="choice_1">
      <!-- graphie -->
      <xsl:choose>
         <xsl:when test="contains($orig, 'true')">
            <xsl:apply-templates select="*:orig"/>
         </xsl:when>
         <xsl:when test="not(contains($orig, 'true'))">
            <xsl:apply-templates select="*:reg"/>
         </xsl:when>
      </xsl:choose>
   </xsl:template>
   <xsl:template name="choice_2">
      <!-- abréviations -->
      <xsl:choose>
         <xsl:when test="contains($abb, 'true') or @rend = 'false'">
            <xsl:apply-templates select="*:abbr"/>
         </xsl:when>
         <xsl:when test="not(contains($abb, 'true'))">
            <xsl:apply-templates select="*:expan"/>
         </xsl:when>
      </xsl:choose>
   </xsl:template>
   <xsl:template name="choice_4">
      <!--  homogénéisations éventuelles des abbréviations -->
      <xsl:choose>
         <xsl:when test="contains($abb, 'true')">
            <xsl:apply-templates select="*:orig"/>
         </xsl:when>
         <xsl:when test="not(contains($abb, 'true'))">
            <xsl:apply-templates select="*:reg"/>
         </xsl:when>
      </xsl:choose>
   </xsl:template>


   <!-- corrections ou sic? -->
   <xsl:template match="*:corr">

      <xsl:choose>
         <xsl:when test="$corr = 'true'">
            <xsl:choose>
               <xsl:when test="@resp = 'author'">
                  <span class="int_author">
                     <xsl:apply-templates/>
                  </span>
                  <xsl:if test="*:figure and not(*:figure/head)">
                     <center>
                        <span class="int_author">[Korrigierte Figur]</span>
                     </center>
                  </xsl:if>
               </xsl:when>
               <xsl:when test="@resp = 'editor'">
                  <span class="int_editor">
                     <xsl:apply-templates/>
                  </span>
                  <xsl:if test="*:figure and not(*:figure/head)">
                     <center>
                        <span class="int_editor">[Korrigierte Figur]</span>
                     </center>
                  </xsl:if>
               </xsl:when>
               <xsl:otherwise>
                  <span class="int_editor">
                     <xsl:apply-templates/>
                  </span>
                  <xsl:if test="*:figure and not(*:figure/head)">
                     <center>
                        <span class="int_editor">[Korrigierte Figur]</span>
                     </center>
                  </xsl:if>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:when>
         <xsl:otherwise>
            <xsl:apply-templates/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="*:signed">
      <p class="noindent" style="text-align:justify; line-height:5em; font-size: 1.15em">
         <xsl:apply-templates/>
      </p>
   </xsl:template>

   <xsl:template match="*:sic">
      <xsl:choose>
         <xsl:when test="$sic = 'true'">
            <span class="int_author">
               <xsl:apply-templates/>
            </span>
            <xsl:if test="*:figure and not(*:figure/head)">
               <center>
                  <span class="int_author">[Fehlerhafte Figur]</span>
               </center>
            </xsl:if>
         </xsl:when>
         <xsl:otherwise/>
      </xsl:choose>
   </xsl:template>



   <xsl:template match="*:add">
      <xsl:choose>
         <xsl:when test="$add = 'true'">
            <xsl:choose>
               <xsl:when test="@resp = '#author'">
                  <span class="int_author">
                     <xsl:if test="node() = ' '">
                        <xsl:text> </xsl:text>
                     </xsl:if>
                     <xsl:apply-templates/>
                  </span>
               </xsl:when>
               <xsl:when test="@resp = '#editor'">
                  <span class="int_editor">
                     <xsl:if test="node() = ' '">
                        <xsl:text> </xsl:text>
                     </xsl:if>
                     <xsl:apply-templates/>
                  </span>
               </xsl:when>
               <xsl:otherwise>
                  <span class="int_other">
                     <xsl:if test="node() = ' '">
                        <xsl:text> </xsl:text>
                     </xsl:if>
                     <xsl:apply-templates/>
                  </span>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:when>
         <xsl:otherwise>
            <xsl:if test="node() = ' '">
               <xsl:text> </xsl:text>
            </xsl:if>
            <xsl:apply-templates/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <xsl:template match="*:del">
      <xsl:choose>

         <xsl:when test="$del = 'true'">
            <xsl:choose>
               <xsl:when test="@resp = '#author'">
                  <span class="int_author"> [<xsl:apply-templates/>] </span>
               </xsl:when>
               <xsl:when test="@resp = '#editor'">
                  <span class="int_editor">[<xsl:apply-templates/>]</span>
               </xsl:when>
               <xsl:otherwise>
                  <span class="int_other">[<xsl:apply-templates/>]</span>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:when>
         <xsl:otherwise/>
      </xsl:choose>
   </xsl:template>


   <!-- ponctuation-->
   <xsl:template match="*:pc">
      <xsl:if test="not(contains($pc, 'true'))">
         <xsl:if test="@type = 't0'">
            <xsl:value-of/>
         </xsl:if>
         <xsl:if test="@type = 't1'">
            <xsl:value-of>. </xsl:value-of>
         </xsl:if>
         <xsl:if test="@type = 't2'">
            <xsl:value-of>, </xsl:value-of>
         </xsl:if>
         <xsl:if test="@type = 't3'">
            <xsl:value-of>? </xsl:value-of>
         </xsl:if>
         <xsl:if test="@type = 't4'">
            <xsl:value-of>! </xsl:value-of>
         </xsl:if>
         <xsl:if test="@type = 't5'">
            <xsl:value-of>; </xsl:value-of>
         </xsl:if>
         <xsl:if test="@type = 't6'">
            <xsl:value-of>: </xsl:value-of>
         </xsl:if>
         <xsl:if test="@type = 't7'">
            <xsl:value-of>–</xsl:value-of>
            <!-- demi cadratin -->
         </xsl:if>
         <xsl:if test="@type = 't8'">
            <xsl:value-of>(</xsl:value-of>
         </xsl:if>
         <xsl:if test="@type = 't9'">
            <xsl:value-of>)</xsl:value-of>
         </xsl:if>
         <xsl:if test="@type = 't10'">
            <xsl:value-of>-</xsl:value-of>
         </xsl:if>
         <xsl:if test="@type = 't11'">
            <xsl:value-of>|</xsl:value-of>
         </xsl:if>
         <xsl:if test="@type = 't12'">
            <xsl:choose>
               <xsl:when test="$lb = 'true'">
                  <xsl:value-of>-</xsl:value-of>
               </xsl:when>
               <xsl:when test="name(following::*[2]) = 'pb'">
                  <xsl:value-of>-</xsl:value-of>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:if>
         <!-- hyphen -->
      </xsl:if>
      <xsl:if test="(contains($pc, 'true'))">
         <xsl:choose>
            <xsl:when test="@type = 't12' and $lb = 'false'"> </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="node()"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:if>

      <xsl:if test="@type = 't13'">
         <xsl:value-of>/</xsl:value-of>
      </xsl:if>
   </xsl:template>

   <xsl:template match="*:am">
      <xsl:if test="not(contains($pc, 'true'))">
         <xsl:if test="@n = 't0'">
            <xsl:value-of/>
         </xsl:if>
         <xsl:if test="@n = 't1'">
            <xsl:value-of>.</xsl:value-of>
         </xsl:if>
         <xsl:if test="@n = 't2'">
            <xsl:value-of>,</xsl:value-of>
         </xsl:if>
         <xsl:if test="@n = 't3'">
            <xsl:value-of>?</xsl:value-of>
         </xsl:if>
         <xsl:if test="@n = 't4'">
            <xsl:value-of>!</xsl:value-of>
         </xsl:if>
         <xsl:if test="@n = 't5'">
            <xsl:value-of>;</xsl:value-of>
         </xsl:if>
         <xsl:if test="@n = 't6'">
            <xsl:value-of>:</xsl:value-of>
         </xsl:if>
         <xsl:if test="@n = 't7'">
            <xsl:value-of>–</xsl:value-of>
         </xsl:if>
         <xsl:if test="@n = 't8'">
            <xsl:value-of>(</xsl:value-of>
         </xsl:if>
         <xsl:if test="@n = 't9'">
            <xsl:value-of>)</xsl:value-of>
         </xsl:if>
         <xsl:if test="@n = 't10'">
            <xsl:value-of>-</xsl:value-of>
         </xsl:if>
         <xsl:if test="@n = 't11'">
            <xsl:value-of>|</xsl:value-of>
         </xsl:if>
      </xsl:if>
      <xsl:if test="(contains($pc, 'true'))">
         <xsl:value-of select="node()"/>
      </xsl:if>
   </xsl:template>


   <xsl:template match="@* | *">
      <xsl:copy>
         <xsl:apply-templates select="@* | node()"/>
      </xsl:copy>
   </xsl:template>

   <xsl:template match="text()">
      <xsl:choose>
         <xsl:when test="not((contains($pc, 'true'))) and following::*[1]/@type = 't2'">
            <xsl:value-of select="replace(., '\s+$', '', 'm')"/>
         </xsl:when>
         <xsl:when test="not((contains($pc, 'true'))) and following::*[1]/@type = 't6'">
            <xsl:value-of select="replace(., '\s+$', '', 'm')"/>
         </xsl:when>
         <xsl:when test="not((contains($pc, 'true'))) and following::*[1]/@type = 't1'">
            <xsl:value-of select="replace(., '\s+$', '', 'm')"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="self::text()"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>


   <!-- ====================================================================== -->
   <!-- Figures, graphics, media and c                                                                -->
   <!-- ====================================================================== -->

   <xsl:template match="*:figure">

      <xsl:choose>
         <xsl:when test="@facs">
            <xsl:variable name="facsID" select="substring(@facs, 2)"/>
            <xsl:variable name="ulx" select="(//*:zone[@xml:id = $facsID]/@ulx)"/>
            <xsl:variable name="uly" select="(//*:zone[@xml:id = $facsID]/@uly)"/>
            <xsl:variable name="lrx" select="(//*:zone[@xml:id = $facsID]/@lrx)"/>
            <xsl:variable name="lry" select="(//*:zone[@xml:id = $facsID]/@lry)"/>
            <xsl:variable name="ulxN" select="concat(0 - $ulx, 'px')"/>
            <xsl:variable name="ulyN" select="concat(0 - $uly, 'px')"/>
            <xsl:variable name="img_src"
               select="//*:graphic[parent::*:surface/*:zone/@xml:id = $facsID]/@url"/>
            <xsl:variable name="widthFacs" select="concat(number($lrx) - number($ulx), 'px')"/>
            <xsl:variable name="heightFacs" select="concat(number($lry) - number($uly), 'px')"/>
            <br/>
            <xsl:if test="parent::*:p or parent::*:item">
               <br/>
            </xsl:if> 
            <xsl:choose>
               <xsl:when test="ancestor::*:note/@type = 'marginalia'">
                  <div id="{@target}"
                     style="width:{$widthFacs}; height:{$heightFacs}; overflow: hidden; position: relative">
                     <img src="{$img_src}" style="position: absolute; top:{$ulyN}; left:{$ulxN}"/>
                  </div>
               </xsl:when>
               <xsl:otherwise>
                  <div align="center">
                     <xsl:if test="child::*:head/*:title[not(@type = 'legend')]">
                        <xsl:apply-templates select="child::*:head"/>
                     </xsl:if>
                     <div
                        style="width:{$widthFacs}; height:{$heightFacs}; overflow: hidden; position: relative">
                        <img src="{$img_src}" style="position: absolute; top:{$ulyN}; left:{$ulxN}"
                        />
                     </div>
                     <p class="noindent"
                        style="text-align:center; line-height:1em; font-size: 0.75em">
                        <xsl:value-of>© </xsl:value-of>
                        <xsl:value-of select="//*:witness/*:orgName"/>
                        <xsl:value-of>, </xsl:value-of>
                        <br/>
                        <a href="{$img_src}" style="color:brown; text-decoration: none;"
                           target="_new">
                           <xsl:value-of select="//*:witness/*:ident[@type = 'catKey']"/>
                           <xsl:value-of>, </xsl:value-of>
                           <xsl:value-of
                              select="//*:surface[descendant::*:zone/@xml:id = $facsID]/@xml:id"/>
                        </a>
                        <xsl:value-of>.</xsl:value-of>
                        <br/>
                        <br/>

                        <xsl:if test="child::*:media">
                           <xsl:apply-templates select="child::*:media"/>
                        </xsl:if>
                        <xsl:if test="child::*:graphic">
                           <xsl:apply-templates select="child::*:graphic"/>
                        </xsl:if>
                     </p>
                     <br/>
                  </div>
               </xsl:otherwise>
            </xsl:choose>

         </xsl:when>
         <xsl:when test="@type = 'double'">
            <div align="center">
               <table border="0" cellpadding="0">
                  <tbody>
                     <tr>
                        <xsl:for-each select="*:figure">
                           <td>
                              <xsl:apply-templates select="."/>
                           </td>
                        </xsl:for-each>
                     </tr>
                  </tbody>
               </table>
            </div>
         </xsl:when>
         <xsl:when test="ancestor::*:note/@type = 'marginalia'">
            <xsl:apply-templates/>

         </xsl:when>
         
         
         <xsl:when test="//*:editionStmt/*:respStmt/*:name/@xml:id = 'page2Tei'">
            <xsl:variable name="pageId" select=" substring(*:graphic/@url, 2)"/>
            
            <xsl:variable name="legend">
               <xsl:if test="//*:witness/*:msDesc/*:msIdentifier/*:institution">
                  <xsl:value-of select="//*:witness/*:msDesc/*:msIdentifier/*:institution"/>
                  <xsl:text>, </xsl:text>
               </xsl:if>
               <xsl:if test="//*:witness/*:msDesc/*:msIdentifier/*:idno">
                  <xsl:value-of select="//*:witness/*:msDesc/*:msIdentifier/*:idno"/>
                  <xsl:text>, </xsl:text>
               </xsl:if>
               <xsl:value-of select=" substring-after(//*:surface[*:zone/@xml:id=$pageId]/@xml:id, '_')"/>
               <xsl:text>, </xsl:text>
               <xsl:if test="//*:witness/*:bibl/*:relatedItem/*:bibl/*:ident/@type='urn'">
                  <xsl:value-of select="//*:witness/*:bibl/*:relatedItem/*:bibl/*:ident[@type='urn']"/>
                  <xsl:text>.</xsl:text>
               </xsl:if>
               <xsl:if test="//*:witness/*:bibl/*:relatedItem/*:bibl/*:ident/@type='url'">
                  <xsl:value-of select="//*:witness/*:bibl/*:relatedItem/*:bibl/*:ident[@type='url']"/>
                  <xsl:text>.</xsl:text>
               </xsl:if>
             
            </xsl:variable>
          
            
            
            <div align="center">
               <xsl:apply-templates/>
               <xsl:value-of select="$pageId"/>
               <p class="noindent"
                  style="text-align:center; line-height:1em; font-size: 0.75em"> 
                  <a style="color:brown; text-decoration: none;"
                     target="_new" href="{//*:surface[*:zone/@xml:id=$pageId]/*:graphic/@url}"><xsl:value-of select="$legend"/></a> 
               </p>
               
               
            </div>        
         </xsl:when>

         <xsl:otherwise>
            <div align="center">
               <xsl:apply-templates/>
            </div>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>


   <xsl:template match="*:graphic">

      <xsl:choose>
         <xsl:when test="//*:editionStmt/*:respStmt/*:name/@xml:id = 'page2Tei'">
            <xsl:variable name="url" select="substring(@url, 2)"/>
            <xsl:variable name="points" select="//*:facsimile/*:surface/*:zone[@xml:id = $url]/@points"/>
            <xsl:variable name="coords" select="tokenize($points, ' ')"/>
            <xsl:variable name="xCoords">
               <xsl:for-each select="$coords">
                  <xsl:variable name="number" select="number(substring-before(., ','))"/>
                  <xsl:if test="string($number) != 'NaN'">
                     <xsl:sequence select="$number"/>
                  </xsl:if>
               </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="x">
               <xsl:value-of select="number(min(tokenize($xCoords, ' ')))*100"/>
            </xsl:variable>
            <xsl:variable name="w" select="number(max(tokenize($xCoords, ' ')))*100 - number($x)"/>
            <xsl:variable name="yCoords">
               <xsl:for-each select="$coords">
                  <xsl:variable name="number" select="number(substring-after(., ','))"/>
                  <xsl:if test="string($number) != 'NaN'">
                     <xsl:sequence select="$number"/>
                  </xsl:if>
               </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="y">
               <xsl:value-of select="number(min(tokenize($yCoords, ' '))) * 100"/>
            </xsl:variable>
            <xsl:variable name="h" select="number(max(tokenize($yCoords, ' ')))*100 - number($y)"/> 
            <xsl:variable name="url">
               <xsl:value-of select="//*:facsimile/*:surface[*:zone/@xml:id = $url]/*:graphic/@url"/>
            </xsl:variable>
            
            <xsl:variable name="region" select="concat('pct:',$x,',',$y,',',$w,',',$h)"/>
            <xsl:variable name="urlRegion" select="replace($url,'full/full/', concat($region,'/pct:30/'))"/>
            
                     
            <a>
               <img src="{$urlRegion}"  alt="image"/>
            </a>
            

         </xsl:when>
         <xsl:otherwise>





            <xsl:variable name="img_src">
               <xsl:choose>
                  <xsl:when test="contains($docId, 'preview')">
                     <xsl:value-of select="unparsed-entity-uri(@entity)"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:choose>
                        <xsl:when test="contains(@url, 'http')">
                           <xsl:value-of select="@url"/>
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:value-of select="concat($figure.path, @url)"/>
                        </xsl:otherwise>
                     </xsl:choose>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:variable>


            <xsl:choose>
               <xsl:when test="parent::*:figure[@facs]">
                  <!-- facsimile + link to transcription -->
                  <a>
                     <xsl:attribute name="href">javascript://</xsl:attribute>
                     <xsl:attribute name="onclick">
                        <xsl:text>javascript:window.open('</xsl:text>
                        <xsl:value-of select="concat($figure.path, @url)"/>
                        <xsl:text>','popup','location=no, width=600,height=600,resizable=yes,scrollbars=yes')</xsl:text>
                     </xsl:attribute>
                     <img src="{$icon.path}transcription.png" width="25" height="25" border="0"
                        alt="Midi"/>
                  </a>
               </xsl:when>
               <xsl:otherwise>


                  <xsl:variable name="height">
                     <xsl:choose>
                        <xsl:when test="@height">
                           <xsl:value-of select="number(substring-before(@height, 'px')) * 0.22"/>
                           <!-- 20% de la taille réelle -->
                        </xsl:when>
                        <xsl:otherwise>100</xsl:otherwise>
                     </xsl:choose>
                  </xsl:variable>
                  <xsl:variable name="width">
                     <xsl:choose>
                        <xsl:when test="@width">
                           <xsl:value-of select="number(substring-before(@width, 'px')) * 0.22"/>
                           <!-- 20% de la taille réelle -->
                        </xsl:when>
                        <xsl:otherwise>100</xsl:otherwise>
                     </xsl:choose>
                  </xsl:variable>
                  <xsl:if test="$anchor.id = @*:id">
                     <a name="X"/>
                  </xsl:if>

                  <br/>
                  <a>
                     <img src="{$img_src}" width="{$width}" alt="image"/>
                  </a>
                  <!-- for figDesc -->
                  <xsl:apply-templates/>
                  <br/>
               </xsl:otherwise>
            </xsl:choose>

         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <xsl:template match="*:media">
      <xsl:if test="@mimeType = 'audio/midi'">
         <br/>
         <a>
            <xsl:attribute name="href">javascript://</xsl:attribute>
            <xsl:attribute name="onclick">
               <xsl:text>javascript:window.open('</xsl:text>
               <xsl:value-of select="concat($midi.path, @url)"/>
               <xsl:text>','popup','location=no, width=600,height=100,resizable=yes,scrollbars=yes')</xsl:text>
            </xsl:attribute>
            <img src="{$icon.path}MIDI.png" width="25" height="25" border="0" alt="Midi"/>
         </a>
      </xsl:if>

      <xsl:if test="@mimeType = 'application/xml'">
         <a>
            <xsl:attribute name="href">javascript://</xsl:attribute>
            <xsl:attribute name="onclick">
               <xsl:text>javascript:window.open('</xsl:text>
               <xsl:value-of select="concat($mei.path, @url)"/>
               <xsl:text>','popup','location=no, width=600,height=100,resizable=yes,scrollbars=yes')</xsl:text>
            </xsl:attribute>
            <img src="{$icon.path}xml.png" width="25" height="25" border="0" alt="MEI"/>
         </a>
      </xsl:if>
   </xsl:template>

   <xsl:template match="*:c">
      <xsl:choose>
         <xsl:when test="//*:editionStmt/*:respStmt/*:name/@xml:id = 'page2Tei'">
            <span style="float:left; font-size:3em; line-height: 90%; text-indent:0; margin-right:0.1em;">
               
             
            
            
            <xsl:apply-templates/>
            </span>
         </xsl:when>
         <xsl:otherwise>
            <xsl:variable name="img_src" select="concat($c.path, @type)"/>
            <img src="{$img_src}" alt="image" height="17"/>
         </xsl:otherwise>
      </xsl:choose>
      
      
      
     
   </xsl:template>

   <!-- ====================================================================== -->
   <!-- PTR and LINKS                                                                -->
   <!-- ====================================================================== -->

   <xsl:template match="*:ptr">
      <xsl:if test="@mimeType = 'application/xml'">


         <xsl:variable name="meiURL">
            <xsl:value-of select="$mei.path"/>
            <xsl:value-of select="@target"/>
         </xsl:variable>

         <xsl:variable name="meiNodeSet" select="document($meiURL)"/>


         <xsl:if test="$meiNodeSet//*:sourceDesc/*:source/@xml:id">
            <!-- more then 2 sources? -->

            <xsl:variable name="httpRefTemp">
               <xsl:choose>
                  <xsl:when test="contains($http.referer, ';&#038;music.id=')">
                     <xsl:value-of select="substring-before($http.referer, ';&#038;music.id=')"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:value-of select="$http.referer"/>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:variable>

            <xsl:for-each select="$meiNodeSet//*:sourceDesc/*:source">
               <br/>
               <a style="color:brown; text-decoration: none;">
                  <xsl:attribute name="href">
                     <xsl:value-of select="$httpRefTemp"/>
                     <xsl:value-of>;&#038;music.id=</xsl:value-of>
                     <xsl:value-of select="@xml:id"/>
                  </xsl:attribute>
                  <xsl:attribute name="target">_top</xsl:attribute>
                  <xsl:value-of select="*:physLoc"/>
               </a>
            </xsl:for-each>
         </xsl:if>

         <xsl:variable name="modifiedMeiNodeSet">
            <xsl:apply-templates select="$meiNodeSet" mode="meiTransform"/>
         </xsl:variable>

         <xsl:choose>
            <xsl:when test="ancestor::*:note/@type = 'marginalia'">
               <span id="{@target}">
                  <xsl:if test="ancestor::*:note/@type = 'marginalia'">
                     <xsl:attribute name="class">absolute-rightMusic</xsl:attribute>
                  </xsl:if>
               </span>
            </xsl:when>
            <xsl:otherwise>
               <div id="{@target}" align="center"/>
            </xsl:otherwise>
         </xsl:choose>

         <xsl:variable name="scale">
            <xsl:choose>
               <xsl:when test="ancestor::*:note/@type = 'marginalia'">20</xsl:when>
               <xsl:otherwise>30</xsl:otherwise>
            </xsl:choose>
         </xsl:variable>

         <xsl:variable name="width">
            <xsl:choose>
               <xsl:when test="ancestor::*:note/@type = 'marginalia'">500</xsl:when>
               <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
         </xsl:variable>

         <!--  <script type="text/javascript">  
            
            
            var vrvToolkit = new verovio.toolkit();
            var example = '<xsl:copy-of select="$modifiedMeiNodeSet"/>';
            var options = JSON.stringify({
            inputFormat: 'mei', 
            scale: <xsl:value-of select="$scale"/>,   
            adjustPageHeight:1,
            pageWidth: <xsl:value-of select="$width"/>
            
            
            })
            
            document.getElementById('<xsl:value-of select="@target"/>').innerHTML = vrvToolkit.renderData(example, options);
            
            console.log(example);
         </script>-->
      </xsl:if>
   </xsl:template>
   <!-- ====================================================================== -->
   <!-- Milestones                                                             -->
   <!-- ====================================================================== -->
   <xsl:template match="*:pb">
      <xsl:choose>
         <xsl:when
            test="ancestor::*[matches(local-name(), '^div')]/descendant::*:del//*:note/@type = 'marginalia' and $del = 'true'">
            <!-- ancestor is div which has descendant note -->
            <div class="pb_resize">
               <xsl:call-template name="create_pb"/>
            </div>
         </xsl:when>
         <xsl:when
            test="ancestor::*[matches(local-name(), '^div')]/descendant::*:note[@type = 'marginalia' and not(ancestor::*:del)]">
            <!-- ancestor is div which has descendant note -->
            <div class="pb_resize">
               <xsl:call-template name="create_pb"/>
            </div>
         </xsl:when>
         <xsl:otherwise>
            <xsl:call-template name="create_pb"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>



   <xsl:template name="create_pb">
      <div class="pb">
         <xsl:variable name="anchor" select="@xml:id"/>
         <a id="{$anchor}"/>


         <xsl:choose>
            <!-- xsl:when test="not(following-sibling::*)"/ -->
            <xsl:when test="$anchor.id = @*:id">
               <a name="X"/>
               <hr class="pb"/>
               <div align="center">&#x2015; <span class="run-head"><xsl:value-of select="@n"
                     /></span> &#x2015;</div>
            </xsl:when>
            <xsl:otherwise>

               <hr class="pb"/>
               <div align="center">&#x2015; <span class="run-head"><xsl:value-of select="@n"
                     /></span> &#x2015;</div>
            </xsl:otherwise>
         </xsl:choose>

         <xsl:variable name="facs" select="substring(./@facs, 2)"/>
         <xsl:variable name="facs.url">
            <xsl:choose>
               <xsl:when test="//*:editionStmt/*:respStmt/*:name/@xml:id = 'page2Tei'">
                  <xsl:value-of select="//*:facsimile/*:surface[@xml:id = $facs]/*:graphic/@url"/>
               </xsl:when>
               
               <xsl:otherwise>
                  <xsl:value-of select="$fac.dir"/>
                  <xsl:value-of select="substring(@facs, 2)"/>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:variable>



         <div align="left">
            <a>
               <xsl:attribute name="href">javascript://</xsl:attribute>
               <xsl:attribute name="onclick">
                  <xsl:text>javascript:window.open('</xsl:text>
                  <xsl:value-of select="$facs.url"/>
                  <xsl:text>','popup','location=no, width=600,height=600,resizable=yes,scrollbars=yes')</xsl:text>
               </xsl:attribute>
               <img src="{$icon.path}books.gif" width="25" height="25" border="0" alt="Facsimile"/>
            </a>
         </div>
         <br/>
      </div>





   </xsl:template>

   <xsl:template match="*:milestone">

      <xsl:if test="$anchor.id = @*:id">
         <a name="X"/>
      </xsl:if>

      <xsl:if test="@rend = 'ornament' or @rend = 'ornamental_break'">
         <div align="center">
            <table border="0" width="40%">
               <tr align="center">
                  <td>&#x2022;</td>
                  <td>&#x2022;</td>
                  <td>&#x2022;</td>
               </tr>
            </table>
         </div>
      </xsl:if>

   </xsl:template>

</xsl:stylesheet>
