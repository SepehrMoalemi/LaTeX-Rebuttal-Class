\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{Classes/decar-wsd}
% Pass all unrecognized options to article class (including font size)
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax
\LoadClass[letterpaper]{article}

\RequirePackage{times}  % TODO Obselete package. Find replacement
\RequirePackage[top=1.0in, bottom=1.0in, left=1.0in, right=1.0in]{geometry}
\RequirePackage{fancyhdr}
\RequirePackage{lastpage}
\RequirePackage{titling}
\RequirePackage[toc,page]{appendix}
\RequirePackage{scrextend}  % Left-justify footnotes
\RequirePackage{paralist}  % Provides enumerate env in paragraphs
\RequirePackage{lastpage}
\RequirePackage{enumitem}

% Header setup
\pagestyle{fancy}
\lhead{}
\chead{} 
\rhead{}
\lfoot{}
\cfoot{\small Submission ID: \@submissionid}
% \lfoot{\small Author's Response to Reviews}
\lfoot{\small Reviews}
\rfoot{\small Page \thepage{}\ of \pageref{endofcontent}}
\renewcommand{\headrulewidth}{0.0pt} 
\renewcommand{\footrulewidth}{0.75pt}

% Header setup for first page
\fancypagestyle{plain}
{
  \fancyhf{}
  \lhead{}
  \chead{}
  \rhead{}
  \cfoot{\small Submission ID: \@submissionid}
  % \lfoot{\small Author's Response to Reviews}
  \lfoot{\small Reviews}
  \rfoot{\small Page \thepage{}\ of \pageref{endofcontent}}
  \renewcommand{\headrulewidth}{0.0pt} 
  \renewcommand{\footrulewidth}{0.75pt}
}

\makeatletter
% Define \submission_id to accept input
\newcommand{\submissionid}[1]{\gdef\@submissionid{#1}}
\def\@maketitle{%
  \newpage
  \null
  \begin{center}%
  \let \footnote \thanks
    {\LARGE \textbf{Reviews of ``\@title''} \par}%
    \vskip 0.1em%
    {\large
      \lineskip .1em%
      \begin{tabular}[t]{c}%
        \emph{\@author}
      \end{tabular}\par}%
    % \vskip .5em%
    % {\large \@date}%
  \end{center}%
  \par
  \begin{center}%
    \rule{\linewidth}{1pt}%
  \end{center}%
  \raggedright}
\makeatother

% Make \subsubsubsection be numbered and appear in TOC
\setcounter{secnumdepth}{5}
\setcounter{tocdepth}{5}

% Left-justify footnotes
\deffootnote[1em]{1em}{1em}{\textsuperscript{\makebox[1em][l]{\thefootnotemark}}}

% TODO Fix title in footer

% Default document title
\title{Weekly Summary Document}
\date{\today{}}
