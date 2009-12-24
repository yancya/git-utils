# See also post-receive-email in git for git repository
# change detection:
#   http://git.kernel.org/?p=git/git.git;a=blob;f=contrib/hooks/post-receive-email
    def git(command)
      @mailer.git(command)
      @mailer.get_record(@revision, record)
    def initialize(mailer, old_revision, new_revision, reference,
      @mailer = mailer
      def initialize(mailer, lines, revision)
        @mailer = mailer
        @new_date = Time.at(@mailer.get_record(@new_revision, "%at").to_i)
        begin
          @old_revision = @mailer.git("log -n 1 --pretty=format:%H #{revision}~").strip
          @old_date = Time.at(@mailer.get_record(@old_revision, "%at").to_i)
        rescue
          @old_revision = '0' * 40
          @old_date = nil
        end
        #@old_revision = git("rev-parse #{revision}~").strip
          when /\Asimilarity index (.*)%\z/
            @similarity_index = $1.to_i
           if @similarity_index == 100 && (@type == :renamed || @type == :copied)
             return ""
           end

           case @type
           when :added
             "--- /dev/null\n" +
             "+++ #{@to_file}    #{format_time(@new_date)} (#{@new_blob})\n"
           when :deleted
             "--- #{@from_file}    #{format_time(@old_date)} (#{@old_blob})\n" +
             "+++ /dev/null\n"
           else
             "--- #{@from_file}    #{format_time(@old_date)} (#{@old_blob})\n" +
             "+++ #{@to_file}    #{format_time(@new_date)} (#{@new_blob})\n"
           end

    attr_reader :revision
    attr_reader :author, :date, :subject, :log, :commit_id
    attr_accessor :reference, :merge_status
    def initialize(mailer, reference, revision)
      @mailer = mailer
      @merge_status = []
    end

    def short_revision
      GitCommitMailer.short_revision(@revision)
      @log = git("log -n 1 --pretty=format:%s%n%n%b #{@revision}")
      @parent_revisions = get_record("%P").split
      output = git("log -n 1 --pretty=format:'' -C -p #{@revision}")
      output = output.lines.to_a
      output.shift #removes the first empty line
      line = output.shift
      lines << line.chomp if line #take out the very first 'diff --git' header
      while line = output.shift
        line.chomp!
          @diffs << DiffPerFile.new(@mailer, lines, @revision)

      @diffs << DiffPerFile.new(@mailer, lines, @revision) if lines.length > 0
      git("log -n 1 --pretty=format:'' -C --name-status #{@revision}").

    def first_parent
      return nil if @parent_revisions.length.zero?

      @parent_revisions[0]
    end

    def other_parents
      return [] if @parent_revisions.length.zero?

      @parent_revisions[1..-1]
    end

    def merge?
      @parent_revisions.length >= 2
    end

    def execute(command)
      result = `#{command} < /dev/null 2> /dev/null`
      raise "execute failed:#{command}" unless $?.exitstatus.zero?
      result
    end

    def git(repository, command)
      execute "git --git-dir=#{repository} #{command}"
    end

    def get_record(repository, revision, record)
      git(repository, "log -n 1 --pretty=format:'#{record}' #{revision}").strip
    def parse_options_and_create(argv=nil)
      mailer
      mailer.send_push_mail = options.send_push_mail
      options.send_push_mail = false
      opts.on("--[no-]send-push-mail",
              "Send push mail") do |bool|
        options.send_push_mail = bool
      end

  attr_writer :from, :add_diff, :show_path, :send_push_mail, :use_utf7
  def create_push_info(*args)
    PushInfo.new(self, *args)
  end

  def create_commit_info(*args)
    CommitInfo.new(self, *args)
  end

  def git(command)
    GitCommitMailer.git(@repository, command)
  end

  def get_record(revision, record)
    GitCommitMailer.get_record(@repository, revision, record)
  end

      git("cat-file -t #@new_revision").strip
      git("cat-file -t #@old_revision").strip
     current_reference_rev = git("rev-parse #@reference").strip
     git("rev-parse --not --branches").lines.find_all do |line|
     end.join(' ')
    git("rev-list #@new_revision #{excluded_revisions}").lines.
    reverse_each do |revision|
      subject = get_record(revision,'%s')
    end
    git("rev-list #@new_revision..#@old_revision").lines.each do |revision|
      subject = get_record(revision, '%s')
    end
      fast_forward = true
      subject = get_record(old_revision,'%s')
    git("rev-list #@old_revision..#@new_revision").lines.each do |revision|
      subject = get_record(revision, '%s')
    end
      baserev = git("merge-base #@old_revision #@new_revision").strip
      git("rev-list #@old_revision..#@new_revision #{excluded_revisions}").lines.
      reverse_each do |revision|
      end
    git("show -s --pretty=oneline #@old_revision")
    git("show -s --pretty=oneline #@old_revision")
    tag_object = git("for-each-ref --format='%(*objectname)' #@reference").strip
    tag_type = git("for-each-ref --format='%(*objecttype)' #@reference").strip
    tagger = git("for-each-ref --format='%(taggername)' #@reference").strip
    tagged = git("for-each-ref --format='%(taggerdate)' #@reference").strip
      prev_tag = git("describe --abbrev=0 #@new_revision^").strip
      msg << "    length  #{git("cat-file -s #{tag_object}").strip} bytes\n"
    tag_content = git("cat-file tag #@new_revision").split("\n")
        msg << git("rev-list --pretty=short \"#{prev_tag}..#@new_revision\" |
                    git shortlog")
        msg << git("rev-list --pretty=short #@new_revision | git shortlog")
  def find_branch_name_from_its_descendant_revision(revision)
    begin
      name = git("name-rev --name-only --refs refs/heads/* #{revision}").strip
      revision = git("rev-parse #{revision}~").strip
    end until name.sub(/([~^][0-9]+)*\z/,'') == name
    name
  end

  def traverse_merge_commit(merge_commit)
    first_grand_parent = git("rev-parse #{merge_commit.first_parent}~").strip

    [merge_commit.first_parent, *merge_commit.other_parents].each do |revision|
      is_traversing_first_parent = (revision == merge_commit.first_parent)
      base_revision = git("merge-base #{first_grand_parent} #{revision}").strip
      base_revisions = [@old_revision, base_revision]
      #branch_name = find_branch_name_from_its_descendant_revision(revision)
      descendant_revision = merge_commit.revision

      until base_revisions.index(revision)
        unless commit_info = @commit_info_map[revision]
          commit_info = create_commit_info(@reference, revision)
          i = @commit_infos.index(@commit_info_map[descendant_revision])
          @commit_infos.insert(i, commit_info)
          @commit_info_map[revision] = commit_info
        else
          commit_info.reference = @reference
        end

        merge_message = "Merged #{merge_commit.short_revision}: #{merge_commit.subject}"
        if not is_traversing_first_parent and not commit_info.merge_status.index(merge_message)
          commit_info.merge_status << merge_message
        end

        if commit_info.merge?
          traverse_merge_commit(commit_info)
          base_revision = git("merge-base #{first_grand_parent} #{commit_info.first_parent}").strip
          base_revisions << base_revision unless base_revisions.index(base_revision)
        end
        descendant_revision, revision = revision, commit_info.first_parent
      end
    end
  end

    commit_infos = @commit_infos.dup
    #@comit_infos may be altered and I don't know any sensible behavior of ruby
    #in such cases. Take the safety measure at the moment...
    commit_infos.reverse_each do |commit_info|
      traverse_merge_commit(commit_info) if commit_info.merge?
    end
    #
    @commit_info_map = {}
    catch (:no_email) do
      push_info_args = each_revision do |revision|
        commit_info = create_commit_info(reference, revision)
        @commit_infos << commit_info
        @commit_info_map[revision] = commit_info
      end
      if push_info_args
        @push_info = create_push_info(old_revision, new_revision, reference,
                                      *push_info_args)
      else
        return
      end
    @info = @push_info
    @push_mail = make_mail
    @commit_mails = []
    @commit_infos.each do |info|
      @commit_mails << make_mail
    end

    #output_rss #XXX eneble this in the future
    [@push_mail, @commit_mails]
  end

  def send_all_mails
    send_mail @push_mail if send_push_mail?

    @commit_mails.each do |mail|
      send_mail mail
    end
  def send_push_mail?
    @send_push_mail
  end

      unless @info.merge_status.length.zero?
        body << "  #{@info.merge_status.join("\n  ")}\n\n"
      end
        similarity_index = " #{diff.similarity_index}%"
        similarity_index = " #{diff.similarity_index}%"
    headers << "Date: #{@info.date.rfc2822}"
      subject << "(push) "
if __FILE__ == $0
    mailer = GitCommitMailer.parse_options_and_create(argv)

    while line = STDIN.gets
      old_revision, new_revision, reference = line.split
      mailer.process_single_ref_change(old_revision, new_revision, reference)
      mailer.send_all_mails
    end
  rescue Exception => error
    require 'net/smtp'
    require 'socket'

    to = []
    subject = "Error"
    from = "#{ENV['USER']}@#{Socket.gethostname}"
    server = nil
    port = nil
    begin
      _to, options = GitCommitMailer.parse(argv)
      to = options.error_to unless options.error_to.empty?
      from = options.from || from
      subject = "#{options.name}: #{subject}" if options.name
      server = options.server
      port = options.port
    rescue OptionParser::MissingArgument
      argv.delete_if {|arg| $!.args.include?(arg)}
      retry
    rescue OptionParser::ParseError
      if to.empty?
        _to, *_ = ARGV.reject {|arg| /^-/.match(arg)}
        to = [_to]
      end
    detail = <<-EOM
  #{error.class}: #{error.message}
  #{error.backtrace.join("\n")}
  EOM
    to = to.compact
    if to.empty?
      STDERR.puts detail
    else
      sendmail(to, from, <<-MAIL, server, port)
  MIME-Version: 1.0
  Content-Type: text/plain; charset=us-ascii
  Content-Transfer-Encoding: 7bit
  From: #{from}
  To: #{to.join(', ')}
  Subject: #{subject}
  Date: #{Time.now.rfc2822}

  #{detail}
  MAIL
    end