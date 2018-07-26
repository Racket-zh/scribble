#lang scribble/doc
@(require scribble/manual scribble/bnf "utils.rkt"
          pict
          (for-label scriblib/figure scribble/base scribble/sigplan
                     (except-in pict table)))

@(define-syntax-rule (samplemod . text) (codeblock . text))
@(define-syntax-rule (sample a . text)
   (codeblock #:context #'a #:keep-lang-line? #f
     "#lang scribble/base" "\n" a . text))
@(define (result . text) (apply nested #:style 'inset text))

@(define sep @hspace[1])

@(define sub*section subsection)

@title[#:tag "getting-started"]{入门}

不管你打算用 Scribble 做什么，去生成一些简单的 HTML 和/或 PDF 文档是个好的开始。
这一章带你过一遍基础的东西，以 @secref["roadmap"] 结尾，其中包含一些目标明确的
如何继续学习的建议。

@section[#:tag "first-example"]{第一个例子}

创建一个包含以下内容的文件 @filepath{mouse.scrbl}：

          @samplemod|{
            #lang scribble/base

            @title{论老鼠吃饼干的习惯}

            如果你给老鼠一块饼干，他会再要一杯牛奶。
          }|

第一行 @racket[#, @hash-lang[] #, @racketmodname[scribble/base]] 表明该文件是个
Scribble 文档。文档起始于“文本模式”，@litchar["@"] 字符用于转义像 @racket[title]
这类的操作符，花括号中的参数以“文本模式”解读传递给操作符。剩余部分是文档内容。

现在运行 @exec{scribble} 命令行程序，指定你希望输出的文档格式：

       @itemize[

         @item{执行
               @commandline{scribble mouse.scrbl}
              生成 HTML 到 @filepath{mouse.html}。
              }

         @item{执行
               @commandline{scribble --htmls mouse.scrbl}
              生成 HTML 到 @filepath{mouse/index.html}。各子节（后面我们会讲到）
              将生成到 @filepath{mouse} 目录下的独立文件。
              }

         @item{执行
                @commandline{scribble --pdf mouse.scrbl}
               生成 PDF 文件 @filepath{mouse.pdf}. 只有在安装了 @exec{pdflatex}
               的情况下这个才可用。如果你想查看 latex 格式的中间文件，尝试执行
                @commandline{scribble --latex mouse.scrbl}
               生成 @filepath{mouse.tex}。
               }
          ]

在章节 @secref["running"] 查看更多关于 @exec{scribble} 命令行工具的信息。

@section{多个小节}

在 @filepath{mouse.scrbl} 中添加更多内容：

          @samplemod|{
            #lang scribble/base

            @title{论老鼠吃饼干的习惯}

            如果你给老鼠一块饼干，他会再要一杯牛奶。

            @section{给牛奶的后果}

            老鼠发出``吱吱'''要牛奶。假设你给他一大杯牛奶。

            他是一只小老鼠，杯子太大---过于大了。于是他可能又要跟你要稻草了。你可能也会给他。

            @section{不是最后一根稻草}

            现在，为了处理沾满牛奶的胡须，要给他一张餐巾。但这没有完...哦，天那。
          }|

        现在文档第一段之后多了两个小节，每个小节通过调用 @racket[section] 创建。
        第一个小节包含两段文字。第二节，从第二个 @racket[section] 调用开始，包含
        一个段落。

再次执行 @secref["first-example"] 中示例过的 @exec{scribble} 命令。你可能已经注
意到了结果中的双引号以及 @litchar{---} 转换成的破折号。

@;----------------------------------------
@section{分割文档源码}

当文档变得越来越大，将各小节分割到不同的源文件更好。@racket[include-section] 操作
符可以用来将多个 @filepath{.scrbl} 文件合并成一个文档。

将前面的示例文档分割成多个文件，把 @filepath{mouse.scrbl} 改成

          @samplemod|{
            #lang scribble/base

            @title{论老鼠吃饼干的习惯}

            如果你给老鼠一块饼干，他会再要一杯牛奶。

            @include-section["milk.scrbl"]
            @include-section["straw.scrbl"]
          }|

在 @filepath{mouse.scrbl} 所在目录创建 @filepath{milk.scrbl} 和 @filepath{straw.scrbl}
文件，在 @filepath{milk.scrbl} 中添加内容：

         @samplemod|{
            #lang scribble/base

            @title{给牛奶的后果}

            老鼠发出``吱吱'''要牛奶。假设你给他一大杯牛奶。

            他是一只小老鼠，杯子太大---过于大了。于是他可能又要跟你要稻草了。你可能也会给他。
          }|

在 @filepath{straw.scrbl} 中添加：

         @samplemod|{
            #lang scribble/base

            @title{不是最后一根稻草}

            现在，为了处理沾满牛奶的胡须，要给他一张餐巾。但这没有完...哦，天那。
          }|

--------------------------------------------------------------------------------
注意到新建的文件和之前的文档一样，也都以 @hash-lang[] 开头，不过原来文档中的
@racket[section] 变成了 @racket[title]。
@filepath{milk.scrbl} 和 @filepath{straw.scrbl} 是独立的文档，有自己的标题，它们
也可以独立的通过 @exec{scribble} 命令渲染。同时当使用 @exec{scribble} 渲染
@filepath{mouse.scrbl} 时，将把这些较小的文件合并成一个，和未分割前的结果一致。

@; ----------------------------------------
@section{Document Styles}

Scribble currently supports only one form of HTML output. You can
replace the @filepath{scribble.css} file for the generated pages, and
that's about it. (We expect to add more styles in the future.)

For Latex-based PDF output, Scribble includes support for
multiple page-layout configurations. The @filepath{mouse.scrbl}
example so far uses the default Latex style. If you plan on submitting
the paper to a workshop on programming languages, then---well, you
probably need a different topic. But you can start making the current
content look right by changing the first line to

          @samplemod|{
            #lang scribble/sigplan
          }|

If you're instead working toward Racket library documentation,
try changing the first line to

          @samplemod|{
            #lang scribble/manual
          }|

which produces output with a separate title page, initial content on
that page (intended as a brief orientation to the document), and
top-level sections turned into chapters that each start on a new page.
If you have split the document into multiple files, the first line of
the main document file determines the output format.

Using @racketmodname[scribble/sigplan] or
@racketmodname[scribble/manual] does not change the rendered HTML for
a document---aside from @racketmodname[scribble/manual] adding a
version number---but it changes the set of bindings available in the
document body. For example, with @racketmodname[scribble/sigplan], the
introductory text can be marked as an abstract:

          @samplemod|{
            #lang scribble/sigplan

            @title{On the Cookie-Eating Habits of Mice}

            @abstract{If you give a mouse a cookie, he's going to
                      ask for a glass of milk.}

            @section{The Consequences of Milk}

            ....}|

When rendered as HTML, the abstract shows up as an inset paragraph. If
you try to use @racket[abstract] with the
@racketmodname[scribble/base] or @racketmodname[scribble/manual]
language, then you get an error, because @racket[abstract] is not
defined.

When a document is implemented across multiple files, changing the
language of the main document can set the style for all of the parts,
but it does not introduce bindings into the other part files. For
example, if you change the language of @filepath{mouse.scrbl} to
@racketmodname[scribble/sigplan], then @racket[abstract] becomes
available in @filepath{mouse.scrbl} but not in @filepath{milk.scrbl}
or @filepath{straw.scrbl}. In other words, operator names are
lexically scoped.

@; ----------------------------------------
@section{More Functions}

The @racketmodname[scribble/base] language provides a collection of
basic operations (and The @racketmodname[scribble/sigplan] and
@racketmodname[scribble/manual] are supersets of
@racketmodname[scribble/base]). Many of the operations are style
variations that you can apply to text:

          @sample|{
            He's a @smaller{small mouse}. The glass is too
            @larger{big}---@bold{way @larger{too @larger{big}}}. So, he'll
            @italic{probably} ask you for a straw.
          }|

which renders as

          @result{
            He's a @smaller{small mouse}. The glass is too
            @larger{big}---@bold{way @larger{too @larger{big}}}. So, he'll
            @italic{probably} ask you for a straw.
          }

As you would expect, calls to functions like @racket[smaller],
@racket[larger], and @racket[bold] can be nested in other calls. They
can also be nested within calls to @racket[title] or @racket[section]:

          @sample|{
            @section{@italic{Not} the Last Straw}
          }|

@sub*section{Centering}

The @racket[centered] operation centers a flow of text:

         @sample|{
           If a mouse eats all your cookies, put up a sign that says
           @centered{
             @bold{Cookies Wanted}

             @italic{Chocolate chip preferred!}
           }
           and see if anyone brings you more.
        }|

which renders as

       @result{
           If a mouse eats all your cookies, put up a sign that says
           @centered{
             @bold{Cookies Wanted}

             @italic{Chocolate chip preferred!}
           }
           and see if anyone brings you more.
       }

@sub*section{Margin Notes}

The @racket[margin-note] operation is used in a similar way, but the
rendered text is moved to the margins.
@margin-note*{If you use @racket[margin-note], then the content shows
             up over here.}

@sub*section{Itemizations}

The @racket[itemlist] operation creates a sequence of bulleted text,
where the @racket[item] operation groups text to appear in a single
bullet. The @racket[itemlist] operation is different from the others
that we have seen before, because it only accepts values produced by
@racket[item] instead of arbitrary text. This difference is reflected
in the use of @litchar{[}...@litchar{]} for the arguments to
@racket[itemlist] instead of  @litchar["{"]...@litchar["}"]:

         @sample|{
           @centered{@bold{Notice to Mice}}

           @itemlist[@item{We have cookies for you.}
                     @item{If you want to eat a cookie,
                           you must bring your own straw.}]
         }|

which renders as

         @result{
           @centered{@bold{Notice to Mice}}

           @itemlist[@item{We have cookies for you.}
                     @item{If you want to eat a cookie,
                           you must bring your own straw.}]
         }

@sub*section{Tables}

The @racket[tabular] function takes a list of lists to organize into a
two-dimensional table. By default, no spacing is added between columns,
so supply a @racket[#:sep] argument to acts as a column separator.
For example,

   @sample|{
     @tabular[#:sep @hspace[1]
              (list (list @bold{Animal} @bold{Food})
                    (list "mouse"       "cookie")
                    (list "moose"       "muffin"))]
   }|

renders as

   @result{
     @tabular[#:sep @hspace[1]
              (list (list @bold{Animal} @bold{Food})
                    (list "mouse"       "cookie")
                    (list "moose"       "muffin"))]
   }

@; ----------------------------------------
@section{Text Mode vs. Racket Mode for Arguments}

When @litchar{[}...@litchar{]} surrounds the arguments of an
operation, the argument expressions are in Racket mode rather than
text mode. Even in Racket mode, @litchar["@"] can be used to apply
operations; once the @"@" syntax is enabled through a
language like @racketmodname[scribble/base] (as opposed to
@racketmodname[racket]), it behaves the same in both Racket mode and
text mode.

One advantage of using Racket mode for the arguments to
@racket[itemlist] is that we can pass a keyword-tagged optional
argument to @racket[itemlist]. In particular, if you want a list with
numbers instead of bullets, supply the @racket['ordered] style to
@racket[itemlist] using the @racket[#:style] keyword:

         @sample|{
           @itemlist[#:style 'ordered
                     @item{Eat cookie.}
                     @item{Drink milk.}
                     @item{Wipe mouth.}
                     @item{...}]
         }|

An operation doesn't care whether it's used with
@litchar{[}...@litchar{]} or @litchar["{"]...@litchar["}"]. Roughly,
@litchar["{"]...@litchar["}"] forms an argument that is a
string. (Only roughly, though. Newlines or uses of @litchar["@"]
within @litchar["{"]...@litchar["}"] complicate the picture, and we'll
get back to that soon.) So,

      @sample|{
          @italic{Yummy!}
      }|

is equivalent to

      @sample|{
          @italic["Yummy!"]
      }|

which is equivalent to the Racket expression

      @racketblock[
          (italic "Yummy!")
      ]

These equivalences explain why Scribble functions are documented in
Racket notation. If you're reading this in HTML format, you can click
@racket[italic] above to access its documentation. The documentation
won't completely make sense, yet, but it will by the end of this
chapter.

What if you want to provide arguments in text mode, but you also want
to supply other optional arguments? You can use both
@litchar{[}...@litchar{]} and @litchar["{"]...@litchar["}"] for an
operation, as long as the @litchar{[}...@litchar{]} is first, and as
long as no character separate the closing @litchar{]} from the
opening @litchar["{"]. For example, calling @racket[italic] is the
same as using @racket[elem] with the @racket['italic] style:

      @sample|{
        @elem[#:style 'italic]{Yummy!}
      }|

You can also @emph{omit} both @litchar{[}...@litchar{]} and
@litchar["{"]...@litchar["}"]. In that case, the Racket expression
after @litchar["@"] is used directly instead of applied as an
operation. For example,

     @sample|{
       1 plus 2 is @(number->string (+ 1 2)).
     }|

renders as

     @result{
       1 plus 2 is @(number->string (+ 1 2)).
     }

The call to @racket[number->string] is needed because a naked number
is not valid as document content.

@; ----------------------------------------
@section[#:tag "how-to:reader"]{@"@" Syntax Basics}

The @"@" notation provided by Scribble is just another way of
writing Racket expressions. Scribble documents could be constructed
using normal Racket notation, without using @"@" at all, but
that would be inconvenient for most purposes. The @"@"
notation makes dealing with textual content much easier.

Whether in text mode or Racket mode, @litchar["@"] in a document
provides an escape to Racket mode. The basic syntax of @litchar["@"] is

@racketblock[
 @#,BNF-seq[@litchar["@"]
             @nonterm{cmd}
             @litchar{[} @kleenestar{@nonterm{datum}} @litchar{]}
             @litchar["{"] @nonterm{text-body} @litchar["}"]]
]

where all three parts after @litchar["@"] are optional, but at least
one must be present. No spaces are allowed between

@itemize[

 @item{@litchar["@"] and @nonterm{cmd}, @litchar{[}, or @litchar["{"]}

 @item{@nonterm{cmd} and @litchar{[} or @litchar["{"]; or}

 @item{@litchar{]} and @litchar["{"].}

]

A @nonterm{cmd} or @nonterm{datum} is normal Racket notation, while a
@nonterm{text-body} is itself in text mode. A @nonterm{cmd} obviously
must not start with @litchar{[} or @litchar["{"], even though Racket
forms could otherwise start with those characters.

The expansion of just @litchar["@"]@nonterm{cmd} into Racket code is

@racketblock[
  @#,nonterm{cmd}
]

When either @litchar{[} @litchar{]} or @litchar["{"] @litchar["}"]
are used, the expansion is

@racketblock[
  (@#,nonterm{cmd} @#,kleenestar{@nonterm{datum}} @#,kleenestar{@nonterm{parsed-body}})
]

where @kleenestar{@nonterm{parsed-body}} is the parse result of the
@nonterm{text-body}. The @kleenestar{@nonterm{parsed-body}} part often
turns out to be a sequence of Racket strings.

In practice, the @nonterm{cmd} is normally a Racket identifier that is
bound to a procedure or syntactic form. If the procedure or form
expects further text to typeset, then @litchar["{"]...@litchar["}"]
supplies the text. If the form expects other data, typically
@litchar{[}...@litchar{]} is used to surround Racket arguments,
instead. Even if an operation's argument is a string, if the string is
not used as content text (but instead used as, say, a hyperlink
label), then the string is typically provided through
@litchar{[}...@litchar{]} instead of @litchar["{"]...@litchar["}"].
Sometimes, both @litchar{[}...@litchar{]} and
@litchar["{"]...@litchar["}"] are used, where the former surround
Racket arguments that precede text to typeset. Finally, if a form is a
purely Racket-level form with not typeset result, such as a
@racket[require] to import more operations, then typically just
@litchar["@"] is used.

For example the text-mode stream

  @sample|{
    @(require scriblib/figure)

    @section[#:tag "poetry"]{Of Mice and Cookies}
    See @secref["milk"].

    @section[#:tag "milk"]{@italic{Important} Milk Supplies}
    @figure["straw" @elem{A straw}]{@image["straw.png"]}
  }|

is equivalent to the Racket-mode sequence

@racketblock[
    (require scriblib/figure) "\n"
    "\n"
    (section #:tag "poetry" "Of Mice and Cookies") "\n"
    "See " (secref "milk") "." "\n"
    "\n"
    (section #:tag "milk" (italic "Important") " Milk Supplies") "\n"
    (figure "straw" (elem "A straw") (image "straw.png")) "\n"
]

Besides showing how different argument conventions are used for
different operations, the above example illustrates how whitespace is
preserved in the Racket form of a text-mode stream---including
newlines preserved as their own strings. Notice how the second
@racket[section] gets two arguments for its content, since the
argument content for @racket[section] in the source stream includes
both the use of an operator and additional text. When an operation
like @racket[section] or @racket[italic] accepts content to typeset,
it normally accepts an arbitrary number of arguments that together
form the content.

In addition to its role for command, a @litchar["@"] can be followed
by @litchar{;} to start a @index['("Scribble"
"comments")]{comment}. If the character after @litchar{;} is
@litchar["{"], then the comment runs until a matching @litchar["}"],
otherwise the comment runs until the end-of-line:

@racketblock[
 @#,BNF-seq[@litchar["@;{"] @nonterm{comment} @litchar["}"]]
 @#,BNF-seq[@litchar["@;"]  @nonterm{line-comment}]
]

For more information on the syntax of @litchar["@"], see
@secref["reader"]. The full syntax includes a few more details, such
as brackets like @litchar["|{"]...@litchar["}|"] for text-mode
arguments while disabling @litchar["@"] between the brackets.

@; ----------------------------------------
@section{Decoding Sequences}

In a document that starts @racket[#, @hash-lang[] #,
@racketmodname[scribble/base]], the top level is a text-mode stream,
just like the @nonterm{text-body} in a @litchar["@"] form. As
illustrated in the previous section, such a top-level sequence
corresponds to a mixture of Racket-mode strings and operation
applications. There's an implicit operation, @racket[decode], that
wraps the whole document to consume this mixture of strings and other
values and turn them into a document description.

The @racket[decode] operation implements @defterm{flow decoding},
which takes a document stream and breaks it up into sections and
paragraphs. Blank lines delimit paragraphs, and the results of
operations like @racket[title] and @racket[section] generate ``here's
the title'' or ``a new section starts here'' declarations that are
recognized by @racket[decode].

A different but related @defterm{content decoding} takes place within
a paragraph or section title. Content decoding is responsible for
converting @litchar{---} to an em dash or for converting @litchar{"}
and @litchar{'} to suitable curly quotes.

The decoding process for document's stream is ultimately determined by
the @hash-lang[] line that starts the document.  The
@racketmodname[scribble/base], @racketmodname[scribble/manual], and
@racketmodname[scribble/sigplan] languages all use the same
@racket[decode] operation.  The @racketmodname[scribble/text] language,
however, acts more like a plain-text generator and preprocessor, and it
does not perform any such decoding rules.  (For more on
@racketmodname[scribble/text], see @other-doc['(lib
"scribblings/scribble/scribble-pp.scrbl")].)

@margin-note{More precisely, languages like
             @racketmodname[scribble/base] apply @racket[decode] only after
             lifting out all definitions and imports from the document
             stream.}

When the flow decoder is used, after it breaks the input stream into
paragraphs, it applies content decoding to strings within the
paragraph. When content is wrapped with an operation, however, content
decoding does not apply automatically. An operation is responsible for
calling a content or flow decoder as it sees fit. Most operations call
the decoder; for example, @racket[italic], @racket[bold],
@racket[smaller], etc., all decode their arguments. Similarly,
@racket[title] and @racket[section] decode the given content for the
title or section name.  The @racket[literal] and @racket[verbatim]
operators, however, do not decode the given strings. For example,

    @sample|{
      @verbatim{---}
    }|

renders as

  @result{
      @verbatim{---}
  }

Don't confuse decoding with the expansion of @"@"
notation. The source form

    @sample|{
      @verbatim{@(number->string (+ 1 2))}
    }|

renders as

  @result{
      @verbatim{@(number->string (+ 1 2))}
  }

because the source is equivalent to

    @racketblock[
      (verbatim (number->string (+ 1 2)))
    ]

where @racket[(number->string (+ 1 2))] is evaluated to produce the
argument to @racket[verbatim]. The @litchar["|{"]...@litchar["}|"]
style of brackets is often used with @racket[verbatim], because
@litchar["|{"]...@litchar["}|"] disables @"@" notation for
arguments. For example,

    @sample|{
      @verbatim|{@(number->string (+ 1 2))}|
    }|

renders as

  @result{
      @verbatim|{@(number->string (+ 1 2))}|
  }


@; ----------------------------------------
@section[#:tag "pictures"]{Pictures}

Any value that is convertable to an image can be used directly within
a Scribble document. Functions from the @racketmodname[pict]
and @racketmodname[2htdp/image #:indirect] libraries, for example, generate
images. For example,

@sample|{
  @(require pict)

  This cookie has lost its chocolate chips:
  @(colorize (filled-ellipse 40 40) "beige").
}|

renders as

 @result{
   This cookie has lost its chocolate chips:
   @(colorize (filled-ellipse 40 40) "beige").
 }


@; ----------------------------------------
@section[#:tag "roadmap"]{Next Steps}

If your immediate goal is to document a Racket library or write
literate programs, skip to @secref["how-to-doc"], and then go back to
@secref["reader"] and other chapters.

If you are more interested in producing documents unrelated to
Racket, continue with @secref["reader"] and then
@secref["generic-prose"].  Move on to @secref["internals"] when you
need more power.

If you are interested in text generation and preprocessing, continue
with @secref["reader"], but then switch to
@other-doc['(lib "scribblings/scribble/scribble-pp.scrbl")].
