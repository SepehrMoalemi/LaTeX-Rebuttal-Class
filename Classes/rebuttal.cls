\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{Classes/rebuttal}
% --------------------------------------------------------------------------------
% Rebuttal Document Class
% --------------------------------------------------------------------------------
% Usage:
%   \documentclass{Classes/rebuttal}
%   \title{Title of the Paper}
%   \author{Author Names}
%   \submissionid{1234}
%   \diffPDFpath{filename.pdf}     % Path to the diff PDF to be appended
%
% Reviewer Section Header:
%   \rebsection{1}
%
% Comment + Response:
% \begin{rebuttal}[resolved] % Options: resolved, pending, stuck, (default: blue)
%     % Comment
%     {%
%         Example of a resolved comment: Why did the scarecrow win an award?
%     }%
%     % Response
%     {%
%         Because he was outstanding in his field.
%     }%
% \end{rebuttal}
%
% Print Rebuttal Statistics:
%   \printStats
%
% Append Diff PDF:
%   \appenddiffPDF
%
% Notes:
% - color-coded reviewer comments (blue, green, orange, red)
% - Automatically count and classify reviewer comments
% - Appends a diff PDF at the end of the document
% --------------------------------------------------------------------------------

% Inherit from article
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax
\LoadClass[letterpaper]{article}

% ---------------- Required Packages ----------------
\RequirePackage{times}
\RequirePackage[top=1in, bottom=1in, left=1in, right=1in]{geometry}
\RequirePackage{fancyhdr}
\RequirePackage{titling}
\RequirePackage{lastpage}
\RequirePackage[toc,page]{appendix}
\RequirePackage{scrextend}  % Justify footnotes
\RequirePackage{enumitem}
\RequirePackage{tcolorbox}
\RequirePackage{etoolbox}
\RequirePackage{xparse}
\RequirePackage{needspace}
\RequirePackage{pdfpages}
\RequirePackage{parskip}      % For paragraph spacing

% ---------------- Page Header/Footer ----------------
\pagestyle{fancy}
\lhead{}
\chead{} 
\rhead{}
\lfoot{\small Authors' Response to Reviews}
\cfoot{\small Submission ID: \@submissionid}
\rfoot{\small Page \thepage{} of \pageref{endofcontent}}
\renewcommand{\headrulewidth}{0pt}
\renewcommand{\footrulewidth}{0.75pt}

\fancypagestyle{plain}{
  \fancyhf{}
  \lfoot{\small Authors' Response to Reviews}
  \cfoot{\small Submission ID: \@submissionid}
  \rfoot{\small Page \thepage{} of \pageref{endofcontent}}
  \renewcommand{\headrulewidth}{0pt}
  \renewcommand{\footrulewidth}{0.75pt}
}

% ---------------- Custom Title Setup ----------------
\makeatletter
\newcommand{\submissionid}[1]{\gdef\@submissionid{#1}}
\def\@maketitle{%
  \newpage
  \null
  \begin{center}%
    {\LARGE \textbf{Authors' Response to Reviews of \\``\@title''} \par}%
    \vskip 0.1em%
    {\large \emph{\@author}\par}
  \end{center}%
  \begin{center}%
    \rule{\linewidth}{1pt}%
  \end{center}%
  \raggedright
}
\makeatother

% ---------------- Colors ----------------
% Define the colors for the comments
\colorlet{ReviewColBackDefault}{blue!7!white}
\colorlet{ReviewColFrameDefault}{blue!50!white}
\colorlet{ReviewColBackResolved}{green!7!white}
\colorlet{ReviewColFrameResolved}{green!80!black}
\colorlet{ReviewColBackPending}{orange!7!white}
\colorlet{ReviewColFramePending}{orange!50!white}
\colorlet{ReviewColBackStuck}{red!7!white}
\colorlet{ReviewColFrameStuck}{red!50!white}

% ---------------- Counters ----------------
% Define a counter for review comments
\newcounter{reviewcommentcounter}
\newcounter{NumberOfComments}
\newcounter{NumberOfResolved}
\newcounter{NumberOfPending}
\newcounter{NumberOfStuck}

% Reset the counter at the beginning of each section
\pretocmd{\section}{\setcounter{reviewcommentcounter}{0}}{}{}

% ---------------- Rebuttal Environment ----------------
\tcbuselibrary{breakable} % For breakable boxes spanning multiple pages
\NewDocumentEnvironment{rebuttal}{O{} +m +m}{%
    % Begin code: Comment Box
    \needspace{10\baselineskip}
    \stepcounter{reviewcommentcounter}%
    \stepcounter{NumberOfComments}%

    % Initialize colors to default (blue)
    \def\ReviewColBack{ReviewColBackDefault}%
    \def\ReviewColFrame{ReviewColFrameDefault}%
    
    % Check optional argument and set colors accordingly
    \ifstrempty{#1}{}{%
        \ifstrequal{#1}{resolved}{%
            \stepcounter{NumberOfResolved}%
            \def\ReviewColBack{ReviewColBackResolved}%
            \def\ReviewColFrame{ReviewColFrameResolved}%
        }{%
            \ifstrequal{#1}{pending}{%
                \stepcounter{NumberOfPending}%
                \def\ReviewColBack{ReviewColBackPending}%
                \def\ReviewColFrame{ReviewColFramePending}%
            }{%
                \ifstrequal{#1}{stuck}{%
                    \stepcounter{NumberOfStuck}%
                    \def\ReviewColBack{ReviewColBackStuck}%
                    \def\ReviewColFrame{ReviewColFrameStuck}%
                }{%
                    % If none of the above, keep default colors (blue)
                }%
            }%
        }%
    }%
    % Now, begin the tcolorbox with the determined colors
    \begin{tcolorbox}[%
        title=Comment~\thereviewcommentcounter, 
        colback=\ReviewColBack,
        colframe=\ReviewColFrame,
        bottomrule=0mm,
        toprule=0mm,
        rightrule=0mm,
        arc=0mm,
        leftrule=0.1mm,
        left=1mm,
        right=1mm,
        top=0.5mm,
        bottom=0.5mm,
        fonttitle=\bfseries\color{black},
        width=\textwidth,
        after=\vspace{-\baselineskip} % Remove spacing after the comment box
    ]%
        #2 % Content of the comment
    \end{tcolorbox}%
    % Begin code: Response Box
    \begin{tcolorbox}[
        colframe=\ReviewColFrame, % Frame color same as the comment
        colback=white,            % Background color for the response
        bottomrule=0.1mm,
        toprule=0mm,
        rightrule=0mm,
        arc=0mm,
        leftrule=0.1mm,
        left=1mm,
        right=1mm,
        top=1mm,
        bottom=0.5mm,
        breakable,
        fonttitle=\bfseries\color{black},
        width=\textwidth,
        before upper={\textbf{Response:} \par\setlength{\parskip}{3pt}}
    ]
    #3 % Content of the response
}
{
    % End code
    \end{tcolorbox}
}

% ---------------- Utility Commands ----------------
% Command to create a new section for each reviewer
\newcommand{\rebsection}[1]{%
  \section*{Reviewer~#1}\label{sec:reviewer#1}%
  \renewcommand{\theequation}{R#1.\arabic{equation}}%
  \setcounter{equation}{0}%
}

% Appending the diff PDF
\newcommand{\diffPDFpath}[1]{\def\pdfPath{#1}}
\newcommand{\appenddiffPDF}{\newpage\includepdf[pages=-]{\pdfPath}}

% Command to print the statistics of the rebuttal on a new page
\newcommand{\printStats}{%
  \newpage
  \thispagestyle{empty}
  \newcount\unanswered
  \unanswered=\numexpr\theNumberOfComments-\theNumberOfResolved-\theNumberOfPending-\theNumberOfStuck\relax
  \begin{center}\Large
    \begin{tabular}{|c|}
      \hline\hline
      \textcolor{black}{Total Number of Comments: \theNumberOfComments} \\
      \textcolor{ReviewColFrameDefault}{Not Responded: \the\unanswered} \\
      \textcolor{ReviewColFrameResolved}{Easy Response: \theNumberOfResolved} \\
      \textcolor{ReviewColFramePending}{Minor Revision: \theNumberOfPending} \\
      \textcolor{ReviewColFrameStuck}{Major Revision: \theNumberOfStuck} \\
      \hline\hline
    \end{tabular}
  \end{center}
}

% ---------------- Default Title ----------------
\title{Title of the Paper}
\author{John Doe and Jane Smith}