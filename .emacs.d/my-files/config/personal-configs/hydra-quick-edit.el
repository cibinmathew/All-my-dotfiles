(defhydra hydra-quick-edit(:color pink)

"
QUICK EDIT:  _d_: kill        _n_: drag down     _e_: pull up
             _r_: replicate   _p_: drag up       _w_: push up
 _7_: redo
"


("w" pull-this-line-up)
("e" pull-next-line-join-region-lines)
("n" drag-stuff-down)
("p" drag-stuff-up)
("d" kill-whole-line )
("r" duplicate-current-line-or-region)
("7" redo)
("q" nil)
)

(provide 'hydra-quick-edit)

