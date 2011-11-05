# encoding: utf-8
# patch for ruby1.9.1 and Rails2.3.5

class Symbol; def to_a; [self.to_s]; end; end

class ::String #:nodoc:
  def to_a
    [self.to_s]
  end
  
  def blank?
    (!self.respond_to?(:valid_encoding?) or self.valid_encoding?) ? self !~ /\S/ : self.strip.size == 0
  end
end

require 'mysql'
class Mysql::Result
  def encode(value, encoding = "utf-8")
    String === value ? value.force_encoding(encoding) : value
  end
  
  def each_utf8(&block)
    each_orig do |row|
      yield row.map {|col| encode(col) }
    end
  end
  alias each_orig each
  alias each each_utf8
 
  def each_hash_utf8(&block)
    each_hash_orig do |row|
      row.each {|k, v| row[k] = encode(v) }
      yield(row)
    end
  end
  alias each_hash_orig each_hash
  alias each_hash each_hash_utf8
end

module ActionController
  class Request
    private
      # Convert nested Hashs to HashWithIndifferentAccess and replace
      # file upload hashs with UploadedFile objects
      def normalize_parameters(value)
        case value
        when Hash
          if value.has_key?(:tempfile)
            upload = value[:tempfile]
            upload.extend(UploadedFile)
            upload.original_path = value[:filename]
            upload.content_type = value[:type]
            upload
          else
            h = {}
            value.each { |k, v| h[k] = normalize_parameters(v) }
            h.with_indifferent_access
          end
        when Array
          value.map { |e| normalize_parameters(e) }
        else
          value.force_encoding(Encoding::UTF_8) if value.respond_to?(:force_encoding)
          value
        end
      end
  end
end

module ActionView
  module Renderable #:nodoc:
    private
      def compile!(render_symbol, local_assigns)
        locals_code = local_assigns.keys.map { |key| "#{key} = local_assigns[:#{key}];" }.join

            #old_output_buffer = output_buffer;#{locals_code};#{compiled_source}
        source = <<-end_src
          # encoding: utf-8
          def #{render_symbol}(local_assigns)
            old_output_buffer = output_buffer;#{locals_code};#{compiled_source.respond_to?(:force_encoding) ? compiled_source.force_encoding(Encoding::UTF_8) : compiled_source}
          ensure
            self.output_buffer = old_output_buffer
          end
        end_src

        begin
          ActionView::Base::CompiledTemplates.module_eval(source, filename, 0)
        rescue Errno::ENOENT => e
          raise e # Missing template file, re-raise for Base to rescue
        rescue Exception => e # errors from template code
          if logger = defined?(ActionController) && Base.logger
            logger.debug "ERROR: compiling #{render_symbol} RAISED #{e}"
            logger.debug "Function body: #{source}"
            logger.debug "Backtrace: #{e.backtrace.join("\n")}"
          end

          raise ActionView::TemplateError.new(self, {}, e)
        end
      end
  end
end
