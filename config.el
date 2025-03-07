;;; Settings

(setq projectile-tags-command "mkaschenko/bin/ctags"
      projectile-tags-file-name "mkaschenko/TAGS"

      minitest-use-bundler nil
      minitest-use-rails t

      rspec-autosave-buffer t
      rspec-command-options "--format progress"
      rspec-primary-source-dirs '("app")
      rspec-spec-command "mkaschenko/bin/test"
      rspec-use-bundler-when-possible nil
      rspec-use-spring-when-possible nil)

;;; Bitbucket

(defun mkaschenko/bitbucket-new-pull-request ()
  (interactive)
  (browse-url "https://bitbucket.org/project-name/pull-requests/new"))

(defun mkaschenko/bitbucket-show-commit ()
  (interactive)
  (let ((url (concat "https://bitbucket.org/project-name/commits/" (thing-at-point 'symbol))))
    (shell-command (concat "echo -n " url " | pbcopy"))
    (message url)))

;;; Gitlab

(defun mkaschenko/gitlab-new-merge-request ()
  (interactive)
  (browse-url (concat "https://gitlab.com/project-name/-/merge_requests/new?merge_request[source_branch]="
                      (shell-command-to-string "echo -n $(git branch --show-current)"))))

;;; Git

(defun mkaschenko/branch-name (name)
  (interactive "sName: ")
  (kill-new
   (message
    (downcase
     (replace-regexp-in-string "[][:'\",\.“”#()]" ""
                               (replace-regexp-in-string "[ -]+" "-"
                                                         (replace-regexp-in-string "[_/>+]" "-" (string-trim name))))))))

;;; Services

(require 's)

(defun mkaschenko/execute (buffer &rest commands)
  (shell buffer)
  (insert (s-join "\n" commands))
  (comint-send-input))

(defun mkaschenko/elasticsearch-service ()
  (interactive)
  (mkaschenko/execute "*Elasticsearch service*"
                      "cd ~/src/project-name/"
                      "./mkaschenko/bin/elasticsearch"))

(defun mkaschenko/postgresql-service ()
  (interactive)
  (mkaschenko/execute "*PostgreSQL service*"
                      "cd ~/src/project-name/"
                      "./mkaschenko/bin/postgresql"))

(defun mkaschenko/rails-service ()
  (interactive)
  (mkaschenko/execute "*Rails service*"
                      "cd ~/src/project-name/"
                      "make s"))

(defun mkaschenko/redis-service ()
  (interactive)
  (mkaschenko/execute "*Redis service*"
                      "cd ~/src/project-name"
                      "redis-server"))

(defun mkaschenko/sidekiq-service ()
  (interactive)
  (mkaschenko/execute "*Sidekiq service*"
                      "cd ~/src/project-name/"
                      "make sidekiq"))

(defun mkaschenko/start-services ()
  (interactive)
  (mkaschenko/elasticsearch-service)
  (mkaschenko/postgresql-service)
  (mkaschenko/rails-service)
  (mkaschenko/redis-service)
  (mkaschenko/sidekiq-service))

;;; Daily report

(defun mkaschenko/daily-report ()
  (interactive)
  (switch-to-buffer "daily-report.txt")
  (beginning-of-buffer)
  (insert "* " (format-time-string "%a %b %d %Y") "\n"
          "  1. \n"
          "  2. \n"
          "\n")
  (beginning-of-buffer)
  (forward-sentence)
  (forward-char))
