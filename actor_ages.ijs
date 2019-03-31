load 'convert/json'

fetch =: [: shell 'curl -s ' , ]
lines =: < ;. _2 @ (, & LF)
json_start =: '<script type="application/ld+json">{'
json_end =: '}</script>'
after =: (1 + ] i. [) }. ]
before =: (] i. [) {. ]
between =: (}. @ [) before (({. @ [) after ])
json_lines =: (json_start ; json_end) & between @ lines
join_lines =: ((>@[),(>@]))/
page_json =: dec_json @ (,&'}') @ ('{'&,) @ join_lines @ json_lines
