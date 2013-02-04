%% Det här är en classfil för att skriva protokoll.
%% Den är främst baserad på protocol.cls av Rahman Amanullah från 19990130
%% Jon Larsson, 2003-07-30
%% Martin Nygren, 2005-06-07
%% Jesper Särnesjö, 2006-10-13, justeringsman -> justeringsperson

%
%			Inledande gunk (paket, avstånd m.m.)
%

\def\fileversion{v1.02}
\def\filedate{2004/05/11}
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{protokoll}[\filedate\ \fileversion]

\RequirePackage{ifthen}
\RequirePackage{graphicx,calc}
\RequirePackage[a4paper]{geometry}
\RequirePackage[T1]{fontenc}
\RequirePackage[utf8]{inputenc}
\RequirePackage[swedish]{babel}

\newboolean{@pdfoutput}
\DeclareOption{pdftex}{\setboolean{@pdfoutput}{true}}
\DeclareOption{dvips,pdftex}{\PassOptionsToPackage{geometry,graphicx}}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions

\LoadClass[a4paper]{article}
\geometry{top=3cm, bottom=3cm, left=2.9cm, right=2.9cm, footskip=10ex}

%% Avstånd
\setlength{\parindent}{0pt}
\setlength{\parskip}{1.2ex}

%% Om en bildfil är vald så gäller följande avstånd
%% Anledningen till två definitioner är för att användaren skall kunna
%% Ändra bredden på bilden.
\newlength{\bildwidth}					% Bredden på bilden.
\newlength{\bildsep}
\setlength{\bildwidth}{7em}
\setlength{\bildsep}{1em}

%% Avst. mellan bild och text.
\newlength{\@bildwidth}
\newlength{\@bildsep}
\setlength{\@bildsep}{0pt}
\setlength{\@bildwidth}{0pt}

%% Några korta avstånd.
\providecommand{\ts}{\thinspace}
\providecommand{\tts}{\kern .11111em}
\providecommand{\ttts}{\kern .05556em}

%
%			Variabler
%

%% Booleska variabler.
\newboolean{@twojust}					% Finns det två justeringsmän?
\newboolean{@motesnr}					% Mötesnummer?
\newboolean{@ordf}						% Ordförande?
\newboolean{@sekr}
\newboolean{@onejust}
\newboolean{@bild}

%% Kommandon för att sätta variabler
\providecommand{\bild}[1]{\gdef\@bild{#1}\setboolean{@bild}{true}}
\providecommand{\typ}[1]{\gdef\@typ{#1}}
\providecommand{\motesnr}[1]{\gdef\@motesnr{#1}%
  \setboolean{@motesnr}{true}}
\providecommand{\datum}[1]{\gdef\@datum{#1}}
\providecommand{\organ}[1]{\gdef\@organ{#1}}
\providecommand{\organisation}[1]{\gdef\@organisation{#1}}
\providecommand{\ordf}[1]{\gdef\mordf{#1}%
  \setboolean{@ordf}{true}}
\providecommand{\sekr}[1]{\gdef\msekr{#1}%
  \setboolean{@sekr}{true}}
\providecommand{\justA}[1]{\gdef\mjustA{#1}%
  \setboolean{@onejust}{true}}
\providecommand{\justB}[1]{\gdef\mjustB{#1}%
  \setboolean{@twojust}{true}}

%% Skriv ut variabler
\providecommand{\skrivordf}{\mordf}
\providecommand{\skrivsekr}{\msekr}
\providecommand{\skrivjustA}{\mjustA}
\providecommand{\skrivjustB}{\mjustB}

%% Är allting angivet?
%\providecommand{\chmotesnr}{\ifthenelse{\boolean{@motesnr}}{}{%
%    \typeout{VARNING: Inget motesnummer angivet.}}}
\providecommand{\chordf}{\ifthenelse{\boolean{@ordf}}{}{%
    \typeout{VARNING: Ingen motesordforande angiven.}\ordf{Valfrid%
    Lindeman}}}
\providecommand{\chsekr}{\ifthenelse{\boolean{@sekr}}{}{%
    \typeout{VARNING: Ingen motessekreterare angiven.}\sekr{Valfrid%
    Lindeman}}}
\providecommand{\chjust}{\ifthenelse{\boolean{@onejust}}{}{%
    \typeout{VARNING: Ingen justeringsperson angiven.}\justA{Valfrid%
    Lindeman}}}

%
%			Formateringskommandon
%

%% Punkter är sections och att-satser är items
\let\punkt\section
\let\att\item

%% Paragraftecken
\providecommand{\S}{\S\ts}

%% Inledande versal
\def\Capthis#1{\uppercase{#1}}
\def\capthis#1{\expandafter\Capthis#1}

%% Sätter rubrik i protokollshuvudet
\providecommand{\rubrik}[1]{\textsf{#1}}

%% En person i närvarolistan
\providecommand{\person}[2]{%
  & #1 & #2\\}

%% Skriv ut mötesfakta
\providecommand{\tid}[1]{\gdef\@tid{#1}\skrivdatumtid}
\providecommand{\skrivdatumtid}{\\ \rubrik{Tidpunkt} & %
  \multicolumn{2}{l}{\@datum,\ \@tid}\\}
\providecommand{\plats}[1]{\\ \rubrik{Plats} & %
  \multicolumn{2}{l}{#1}\\}
\providecommand{\narvarande}{\\ \rubrik{Närvarande}}
\providecommand{\franvarande}{\\ \rubrik{Frånvarande}}

%
%			Övriga kommandon
%

%% För att skriva ut hur många sidor totalt som finns.
%% Lånat från lastpage-paketet av Jeff Goldberg från 940625.
\def\lastpage@putlabel{%
    \immediate\write\@auxout{\string
    \newlabel{LastPage}{{}{\thepage}}}%
}

%
%			Miljöer
%

%% Beslut
\newenvironment{beslut}{%
  %% Början
  \par\vspace{1ex}%
  \textbf{\@organ\ beslutade}%
  \vspace{-1ex}%
  \begin{list}{\emph{att}}{}}
  %% Slutet
  {\end{list}}

%% Protokollhuvudet (mötesfakta)
\newenvironment{motesfakta}{%
  %% Början
  \begin{tabular}{@{\hspace{-0.27em}}l l l}}
  %% Slutet
  {\end{tabular}%
   \vspace{2ex}}

%
%			Pagestyle
%

%% Kontrollerar om ordförande och justeringsperson är angivna och sätter
%% sedan ut sidfoten beroende på om en eller två justeringsmän är
%% angivna.
\providecommand{\ps@protokoll}{%
  \renewcommand{\@oddhead}{\emph{\@organisation\hfill\capthis\@typ\space%
      \@datum\hfill\thepage (\pageref{LastPage})}}%
  \renewcommand{\@evenhead}{\@oddhead}%
  \renewcommand{\@oddfoot}{%
    \chjust\footnotesize\ifthenelse{\boolean{@twojust}}{%
      \parbox[l]{\textwidth}{%
        \begin{tabular}{@{}p{4cm} l  @{\hspace{1cm}} p{4cm} l%
            @{\hspace{1cm}} p{4cm}}
          \cline{1-1}\cline{3-3}\cline{5-5}\\[-2ex]
          \mjustA & & \mjustB & & \mordf\\
        \end{tabular}}}{%
      \parbox[l]{\textwidth}{%
        \begin{tabular}{@{} p{5.5cm} c @{\hspace{2cm}} p{5.5cm}}
        \cline{1-1} \cline{3-3}\\[-2ex]
        \mjustA & & \mordf\\
      \end{tabular}}}}%
  \renewcommand{\@evenfoot}{\@oddfoot}}

%% Sista sidan ska inte ha justeringssidfot
\providecommand{\ps@lastpage}{%
  \renewcommand{\@evenfoot}{}%
  \renewcommand{\@oddfoot}{}}

%
%			Dokumentets början och slut
%

%% Blandade initialvärden
\pagestyle{protokoll}
\typ{styrelsemöte}
\organisation{Maxwells Demoner}

%% Fixa förstasidan
\AtBeginDocument{%
  \phantom{Tjoho}%
  \vspace{0.5cm}%
  %% Använd en bildfil om den är angiven.
  \ifthenelse{\boolean{@bild}}%{\IfFileExists{\@bild}%
    {\setlength{\@bildwidth}{\bildwidth}%
      \setlength{\@bildsep}{\bildsep}%
      \parbox[l]{\@bildwidth}{%
        \ifthenelse{\boolean{@pdfoutput}}{%
          \pdfimage width \@bildwidth \@bild}{%
          \includegraphics[width=\@bildwidth]{\@bild}}}
      \parbox[l]{\@bildsep}{}%}%
    }{}%{\typeout{VARNING: Filen \@bild\ kan inte hittas.}}}{}%
  \parbox{\textwidth-\@bildwidth-\@bildsep}{%
    \textbf{\LARGE Protokoll fört vid \@typ\ \ifthenelse{\boolean{@motesnr}}%
      {nr~\@motesnr\ }}\\[1ex]
    \textsc{\LARGE \@organisation}}\\[1ex]
  \vspace{0.5cm}%
  }

%% Sist i protokollet ska underskrifterna skrivas ut
\AtEndDocument{
  %\pagestyle{lastpage}\thispagestyle{protokoll}
  \vspace{2cm}\chordf\chjust\chsekr%
  \ifthenelse{\boolean{@twojust}}{\parbox[b]{15cm}{%
      \begin{tabular}{@{} p{6cm} l @{\hspace{2cm}} p{6cm}}
        \cline{1-1}\cline{3-3}\\[-2ex]
        {\footnotesize\msekr, mötessekreterare} & &
        {\footnotesize\mordf, mötesordförande}\\[1.5cm]
        \cline{1-1}\cline{3-3}\\[-2ex]
        {\footnotesize\mjustA, justeringsperson} & &
        {\footnotesize\mjustB, justeringsperson}\\
      \end{tabular}}}{\parbox[b]{15cm}{
      \begin{tabular}{@{} p{6cm} l @{\hspace{2cm}} p{6cm}}
       \cline{1-1}\cline{3-3}\\[-2ex]
       {\footnotesize\msekr, mötessekreterare} & &
       {\footnotesize\mordf, mötesordförande}\\[1.5cm]
       \cline{1-1}\\[-2ex]
       {\footnotesize\mjustA, justeringsperson} & &\\
      \end{tabular}}}
  \thispagestyle{lastpage}
  \ifthenelse{\equal{\pageref{LastPage}}{\thepage}}{}{\typeout{}%
    \typeout{TYPSÄTT ÄNNU EN GÅNG FÖR ATT FÅ RÄTT SISTA SIDA!}%
    \typeout{}}
  \lastpage@putlabel}
