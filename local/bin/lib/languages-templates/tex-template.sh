#!/bin/bash

basicTemplate=$(cat << EOF
% Define the document type and font size
\documentclass[12pt]{article}

\usepackage[spanish]{babel} % Package for the Spanish language
\usepackage[utf8]{inputenc} % Package for UTF-8 character encoding
\usepackage{geometry} % Package to configure document margins
\usepackage{listings} % Package to include source code in the document
\usepackage{xcolor} % Package to define colors
\usepackage{fancyhdr} % Package to customize headers and footers
\usepackage{amsmath} % Package for advanced mathematical symbols and environments
\usepackage{amssymb} % Package for additional mathematical symbols

\setlength{\parskip}{1em} % Space between paragraphs
\setlength{\parindent}{0pt} % Without indentation for paragraphs

% Definition of colors for source code
\definecolor{KEYWORDS}{HTML}{0000ff}
\definecolor{COMMENTS}{HTML}{888888}
\definecolor{STRINGS}{HTML}{ff0000}

% Configuration of the listings environment to display source code
\lstset{
	frame=shadowbox,
	language=c++,
	aboveskip=3mm,
	belowskip=3mm,
	xleftmargin=10mm,
	xrightmargin=10mm,
	showstringspaces=false,
	columns=flexible,
	basicstyle={\small\ttfamily},
	numbers=left,
	numberstyle=\tiny\color{COMMENTS},
	keywordstyle=\color{KEYWORDS},
	commentstyle=\color{COMMENTS},
	stringstyle=\color{STRINGS},
	breaklines=true,
	breakatwhitespace=true,
	tabsize=4
}

% Configuration of document margins
\geometry{
	a4paper,
	left=25mm,
	right=25mm,
	top=25mm,
	bottom=25mm
}

\title{Document Dame} % Document title
\author{Druxorey} % Document author
\date{\today} % Document date

% Configuration of headers and footers
\pagestyle{fancy}
\fancyhf{}
\fancyhead[L]{Left Header}
\fancyhead[C]{Center Header}
\fancyhead[R]{Right Header}
\fancyfoot[L]{Left Footer}
\fancyfoot[C]{Center Footer}
\fancyfoot[R]{\thepage}
\setlength{\headheight}{14.5pt}
\addtolength{\topmargin}{-2.5pt}

\begin{document}

\begin{titlepage}
	\centering
	\vspace{1cm}
	{\large {University}\par}
	{\large {Faculty}\par}
	{\large {School}\par}
	{\large {Subject}\par}
	\vspace{8cm}
	{\LARGE \textbf{Document Name}\par}
	\vspace{0.5cm}
	{\Large \textbf{Subtitle}\par}
	\vfill
	{\large Druxorey\par}
	\vspace{0.5cm}
	{\large \today\par}
\end{titlepage}

\section{Introduction}
This document contains several examples of code in C++. The purpose of this document is to demonstrate how different features of the C++ language can be structured and used.

\pagebreak

\section{Basic Function Example}
The following code demonstrates a basic function in C++ that calculates the factorial of a number.

\begin{lstlisting}[language=C++, caption=Factorial Function, label=code:factorial]
#include <iostream>

int factorial(int n) {
	if (n <= 1) return 1;
	else return n * factorial(n - 1);
}

int main() {
	int number = 5;
	std::cout << "Factorial of " << number << " is " << factorial(number) << std::endl;
	return 0;
}
\end{lstlisting}

\section{Mathematical Operations}
\subsection{Continuous Mathematics}
The following is an example of a mathematical operation, specifically the quadratic formula:

\[x = \frac{-b \pm \sqrt{b^2 - 4ac}}{2a}\]

\subsection{Discrete Mathematics}
An important concept in discrete mathematics is the use of quantifiers. The universal quantifier (\(\forall\)) and the existential quantifier (\(\exists\)) are used to express statements involving all elements or some elements of a set, respectively. For example:

\[\forall x \in \mathbb{N}, \; P(x) \implies Q(x)\]

\[\exists y \in \mathbb{N}, \; P(y) \land Q(y)\]

Logical connectives such as conjunction (\(\land\)) and disjunction (\(\lor\)) are also commonly used:

\[P(x) \land Q(x)\]

\[P(x) \lor Q(x)\]

\pagebreak

\section{Conclusion}
In conclusion, C++ is a powerful and versatile programming language that allows developers to create efficient and robust applications. The examples presented in this document show some of the basic features of the language.

\end{document}
EOF
)
