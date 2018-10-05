;;Файл конфигурации для emacs windows
;; reload setting M-x load-file [ENTER] ~/.emacs
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;Добавляем пути для поиска загружаемых модулей
(add-to-list 'load-path "~/emacs/configs")
(add-to-list 'load-path "~/emacs/modules")
(add-to-list 'load-path "~/emacs/modules/color-theme")

;;Добавляем пути для тем
(add-to-list 'custom-theme-load-path "~/emacs/colors/emacs-color-theme-solarized-master")
(add-to-list 'custom-theme-load-path "~/emacs/colors/emacs-professional-theme-master")
;;

(setq-default tab-width 4)

;; Autopair is an extension to the Emacs text editor that automatically pairs braces and quotes:
;; - Opening braces/quotes are autopaired;
;; - Closing braces/quotes are autoskipped;
;; - Backspacing an opening brace/quote autodeletes its pair.
;; - Newline between newly-opened brace pairs open an extra indented line.
;; https://github.com/joaotavora/autopair
(require 'autopair)
(autopair-global-mode) ;; enable autopair in all buffers

;;Загрузка пакета ido для перемещения между открытыми буферами нажатием C-x b
;;Работает параллельно умолчальному поведению, входит в стандартную поставку
;(require 'ido)
;(ido-mode t)

;;
(add-to-list 'load-path
			 "~/emacs/modules/yasnippet")

(require 'yasnippet)
(yas-global-mode 1)



;(provide 'init-yasnippet)



;;This is one vi feature I am addicted to and which made the change to emacs tough because emacs does not have a direct way to do this even under it's various programming modes. Below is some emacs lisp code that I picked off from the Internet that will map the % key to do exactly what vi does. A big thanks to whoever wrote this. (Thanks to Eric Pement (Sed FAQ) for pointing out that this is from the Emacs FAQ). What you need to do is open the file .emacs under your home directory and stick the following lines as is in the file. Close and re-open emacs and, presto, you can use the % like you do in vi. Note that I have not tested this extensively, but it seems to work.


(global-set-key "%" 'match-paren)

(defun match-paren (arg)
"Go to the matching paren if on a paren; otherwise insert %."
(interactive "p")
(cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
((looking-at "\\s\)") (forward-char 1) (backward-list 1))
(t (self-insert-command (or arg 1)))))


;;activate show paren
(show-paren-mode t)
(setq show-paren-style 'expression) 


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Установка правил поведения редактора
;;
;;загружается молча
(setq inhibit-startup-message t)
;; Scratch buffer settings. Очищаем его.
(setq initial-scratch-message nil)
;; Вырубаем tool-bar
(tool-bar-mode -1)
;; Disable auto-save
(setq auto-save-default nil)
;; prevent emacs from creating the backup file
(setq make-backup-files nil) 

;;(load-theme 'solarized t)
(load-theme 'professional t)
;;(load-theme 'adwaita t)

;;(require 'color-theme)
;;(eval-after-load "color-theme"
;;  '(progn
;;    (color-theme-initialize)
;;     (color-theme-calm-forest)))

;; change buffer encoding
;; C-x <ENTER> r <указать-требуемую-кодировку> <ENTER> yes <ENTER>
;; https://pa2311.blogspot.ru/2014/04/emacs_30.html
(setq my-working-codings ["utf-8" "windows-1251" "koi8-r" "cp866"])
(setq my-current-coding-index -1)
(defun pa23-change-coding ()
  "Change coding for current buffer."
  (interactive)
  (let (my-current-eol
        my-next-coding-index
        my-new-coding-system
        my-new-coding)
    (setq my-current-eol
          (coding-system-eol-type buffer-file-coding-system))
    (setq my-next-coding-index (1+ my-current-coding-index))
    (if (equal my-next-coding-index (length my-working-codings))
        (setq my-next-coding-index 0))
    (setq my-new-coding-system
          (elt my-working-codings my-next-coding-index))
    (cond ((equal my-current-eol 0)
           (setq my-new-coding (concat my-new-coding-system "-unix")))
          ((equal my-current-eol 1)
           (setq my-new-coding (concat my-new-coding-system "-dos")))
          ((equal my-current-eol 2)
           (setq my-new-coding (concat my-new-coding-system "-mac"))))
    (setq coding-system-for-read (read my-new-coding))
    (revert-buffer t t)
    (setq my-current-coding-index my-next-coding-index)
    (message "Set coding %s." my-new-coding)
    )
  )
(global-set-key [f12] 'pa23-change-coding)

;; change line endings
;; https://pa2311.blogspot.ru/2014/04/emacs_29.html
(defun pa23-change-eol ()
  "Change EOL for current buffer."
  (interactive)
  (let (my-current-eol
        my-new-eol
        my-new-coding)
    (setq my-current-eol
          (coding-system-eol-type buffer-file-coding-system))
    (if (equal my-current-eol 2)
        (setq my-new-eol 0)
      (setq my-new-eol (1+ my-current-eol)))
    (setq my-new-coding
          (coding-system-change-eol-conversion
           buffer-file-coding-system my-new-eol))
    (set-buffer-file-coding-system my-new-coding)
    )
  )
(global-set-key [f9] 'pa23-change-eol)

;; ;; Поддержка русской кодировки MS Windows
;; ;(codepage-setup 1251)  
;; ;синонимы для cp1251
;; (define-coding-system-alias 'windows-1251 'cp1251)
;; (define-coding-system-alias 'win-1251 'cp1251)

;; (set-input-mode nil nil 'We-will-use-eighth-bit-of-input-byte)

;; ;; Create Cyrillic-CP1251 Language Environment menu item
;; (set-language-info-alist
;;  "Cyrillic-CP1251" `((charset cyrillic-iso8859-5)
;; 		   (coding-system cp1251)
;; 		   (coding-priority cp1251)
;; 		   (input-method . "cyrillic-jcuken")
;; 		   (features cyril-util)
;; 		   (unibyte-display . cp1251)
;; 		   (sample-text . "Russian (Русский)    Здравствуйте!")
;; 		   (documentation . "Support for Cyrillic CP1251."))
;;  '("Cyrillic"))

;; Line Numbers
;; Linum Mode is old and some buggy
(global-linum-mode 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; HTML Support
;;
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
;
(add-to-list 'auto-mode-alist '("\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))

; настройка отступов
(setq web-mode-markup-indent-offset 2)
(setq web-mode-css-indent-offset 2)
(setq web-mode-code-indent-offset 2)

; подсвечивать текущий элемент
(setq web-mode-enable-current-element-highlight t)


;;; JS
(require 'json-mode)
(add-to-list 'load-path "~/emacs/modules/js2-mode")
(require 'js2-mode)
(add-to-list 'auto-mode-alist '("\\.js" . js2-mode))
;;(require 'ac-js2)
;;(require 'coffee-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PowerShell
(require 'powershell-mode)
(add-to-list 'auto-mode-alist '("\\.ps1\\'" . powershell-mode))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
