%% Det h�r �r en classfil f�r att skriva protokoll.
%% Den �r fr�mst baserad p� protocol.cls av Rahman Amanullah fr�n 19990130
%% Jon Larsson, 2003-07-30
%% Martin Nygren, 2005-06-07
%% Jesper S�rnesj�, 2006-10-13, justeringsman -> justeringsperson

%
%			Inledande gunk (paket, avst�nd m.m.)
%

\def\fileversion{v1.02}
\def\filedate{2004/05/11}
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{dagordning}[\filedate\ \fileversion]

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

%% Avst�nd
\setlength{\parindent}{0pt}
\setlength{\parskip}{1.2ex}

%% Om en bildfil �r vald s� g�ller f�ljande avst�nd
%% Anledningen till tv� definitioner �r f�r att anv�ndaren skall kunna
%% �ndra bredden p� bilden.
\newlength{\bildwidth}					% Bredden p� bilden.
\newlength{\bildsep}
\setlength{\bildwidth}{7em}
\setlength{\bildsep}{1em}

%% Avst. mellan bild och text.
\newlength{\@bildwidth}
\newlength{\@bildsep}
\setlength{\@bildsep}{0pt}
\setlength{\@bildwidth}{0pt}

%% N�gra korta avst�nd.
\providecommand{\ts}{\thinspace}
\providecommand{\tts}{\kern .11111em}
\providecommand{\ttts}{\kern .05556em}

%
%			Variabler
%

%% Booleska variabler.
\newboolean{@twojust}					% Finns det tv� justeringsm�n?
\newboolean{@motesnr}					% M�tesnummer?
\newboolean{@ordf}						% Ordf�rande?
\newboolean{@sekr}
\newboolean{@onejust}
\newboolean{@bild}

%% Kommandon f�r att s�tta variabler
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

%% �r allting angivet?
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

%% Punkter �r sections och att-satser �r items
\let\punkt\section
\let\att\item

%% Paragraftecken
\providecommand{\�}{\S\ts}

%% Inledande versal
\def\Capthis#1{\uppercase{#1}}
\def\capthis#1{\expandafter\Capthis#1}

%% S�tter rubrik i protokollshuvudet
\providecommand{\rubrik}[1]{\textsf{#1}}

%% En person i n�rvarolistan
\providecommand{\person}[2]{%
  & #1 & #2\\}

%% Skriv ut m�tesfakta
\providecommand{\tid}[1]{\gdef\@tid{#1}\skrivdatumtid}
\providecommand{\skrivdatumtid}{\\ \rubrik{Tidpunkt} & %
  \multicolumn{2}{l}{\@datum,\ \@tid}\\}
\providecommand{\plats}[1]{\\ \rubrik{Plats} & %
  \multicolumn{2}{l}{#1}\\}
\providecommand{\narvarande}{\\ \rubrik{N�rvarande}}
\providecommand{\franvarande}{\\ \rubrik{Fr�nvarande}}

%
%			�vriga kommandon
%

%% F�r att skriva ut hur m�nga sidor totalt som finns.
%% L�nat fr�n lastpage-paketet av Jeff Goldberg fr�n 940625.
\def\lastpage@putlabel{%
    \immediate\write\@auxout{\string
    \newlabel{LastPage}{{}{\thepage}}}%
}

%
%			Milj�er
%

%% Beslut
\newenvironment{beslut}{%
  %% B�rjan
  \par\vspace{1ex}%
  \textbf{\@organ\ beslutade}%
  \vspace{-1ex}%
  \begin{list}{\emph{att}}{}}
  %% Slutet
  {\end{list}}

%% Protokollhuvudet (m�tesfakta)
\newenvironment{motesfakta}{%
  %% B�rjan
  \begin{tabular}{@{\hspace{-0.27em}}l l l}}
  %% Slutet
  {\end{tabular}%
   \vspace{2ex}}

%
%			Pagestyle
%

%% Kontrollerar om ordf�rande och justeringsperson �r angivna och s�tter
%% sedan ut sidfoten beroende p� om en eller tv� justeringsm�n �r
%% angivna.
\providecommand{\ps@dagordning}{%
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
%        \cline{1-1} \cline{3-3}\\[-2ex]
%        \mjustA & & \mordf\\
      \end{tabular}}}}%
  \renewcommand{\@evenfoot}{\@oddfoot}}

%% Sista sidan ska inte ha justeringssidfot
\providecommand{\ps@lastpage}{%
  \renewcommand{\@evenfoot}{}%
  \renewcommand{\@oddfoot}{}}

%
%			Dokumentets b�rjan och slut
%

%% Blandade initialv�rden
\pagestyle{dagordning}
\typ{styrelsem�te}
\organisation{Maxwells Demoner}

%% Fixa f�rstasidan
\AtBeginDocument{%
  \phantom{Tjoho}%
  \vspace{0.5cm}%
  %% Anv�nd en bildfil om den �r angiven.
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
    \textbf{\LARGE Dagordning \@typ\ \@datum\ \ifthenelse{\boolean{@motesnr}}%
      {nr~\@motesnr\ }}\\[1ex]
    \textsc{\LARGE \@organisation}}\\[1ex]
  \vspace{0.5cm}%
  }

%% Sist i protokollet ska underskrifterna skrivas ut
\AtEndDocument{
  %\pagestyle{lastpage}\thispagestyle{protokoll}
  \vspace{2cm}\chordf\chjust\chsekr%

%  \ifthenelse{\boolean{@twojust}}{\parbox[b]{15cm}{%
%      \begin{tabular}{@{} p{6cm} l @{\hspace{2cm}} p{6cm}}
%        \cline{1-1}\cline{3-3}\\[-2ex]
%        {\footnotesize\msekr, m�tessekreterare} & &
%        {\footnotesize\mordf, m�tesordf�rande}\\[1.5cm]
%        \cline{1-1}\cline{3-3}\\[-2ex]
%        {\footnotesize\mjustA, justeringsperson} & &
%        {\footnotesize\mjustB, justeringsperson}\\
%      \end{tabular}}}{\parbox[b]{15cm}{
%      \begin{tabular}{@{} p{6cm} l @{\hspace{2cm}} p{6cm}}
%       \cline{1-1}\cline{3-3}\\[-2ex]
%       {\footnotesize\msekr, m�tessekreterare} & &
%       {\footnotesize\mordf, m�tesordf�rande}\\[1.5cm]
%       \cline{1-1}\\[-2ex]
%       {\footnotesize\mjustA, justeringsperson} & &\\
%      \end{tabular}}}
  \thispagestyle{lastpage}
  \ifthenelse{\equal{\pageref{LastPage}}{\thepage}}{}{\typeout{}%
    \typeout{TYPS�TT �NNU EN G�NG F�R ATT F� R�TT SISTA SIDA!}%
    \typeout{}}
  \lastpage@putlabel}
