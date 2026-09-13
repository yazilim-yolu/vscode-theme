# frozen_string_literal: true

#
# Ruby — tema testi.
# Modüller, mixin'ler, blok/proc/lambda, sembol ve string çeşitleri.
#

require 'json'
require 'set'
require_relative 'sample'

VERSION = '0.2.1'
BANNER = 'Yazılım Yolu'

module Renderable
  SEVIYELER = { debug: 10, info: 20, warn: 30, error: 40 }.freeze

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def banner = BANNER
  end

  def render
    raise NotImplementedError, "#{self.class}#render tanımlı değil"
  end
end

module Taggable
  attr_accessor :tags

  def add_tag(*names, **opts, &block)
    @tags ||= []
    names.each do |name|
      @tags << (block ? block.call(name) : name.to_s)
    end
    @tags.uniq!
    self
  end
end

class Task
  include Renderable
  include Taggable
  include Comparable

  attr_reader :id
  attr_writer :title

  @@count = 0
  ETIKET = /\A#(?<ad>\w+)\z/i

  class << self
    def create(...) = new(...)

    def count = @@count
  end

  def initialize(id, title = 'isimsiz', done: false, tags: [])
    @id      = Integer(id)
    @title   = title
    @done    = done
    @tags    = Array(tags)
    @@count += 1
  end

  def done? = @done

  def toggle! = (@done = !@done)

  def <=>(other) = id <=> other.id

  def to_s = format('%s#%d<%s>', self.class, @id, @title)

  def to_h = { id: @id, title: @title, done: @done, tags: @tags }

  def render
    "#{done? ? '✓' : '·'} #{@title.ljust(20)} #{@tags.inspect}"
  end

  def method_missing(name, *args)
    return @tags.include?(name.to_s) if name.to_s.end_with?('?')

    super
  end

  def respond_to_missing?(name, include_private = false)
    name.to_s.end_with?('?') || super
  end

  protected

  def raw = @title

  private

  def slug = @title.downcase.tr(' ', '-')
end

class Board < Task
  include Enumerable

  def initialize(*tasks)
    super(0, 'board')
    @tasks = tasks
  end

  def each(&) = @tasks.each(&)

  def render = map(&:render).join("\n")
end

def siniflandir(value)
  case value
  when nil            then 'yok'
  when true, false    then value.to_s
  when Integer        then value.positive? ? "pozitif #{value}" : 'negatif'
  when Float          then format('%.4f', value)
  when /\A\d+\z/      then 'sayısal metin'
  when Array          then "dizi(#{value.size})"
  when Hash           then value.keys.join(',')
  when Renderable     then value.render
  when ->(v) { v.respond_to?(:call) } then 'çağrılabilir'
  else                     value.class.name
  end
end

sayilar = [0b1010, 0o755, 0xDEAD, 1_000_000, -42, 3.14e-2]
semboller = %i[mor turkuaz lacivert]
kelimeler = %w[tema test renk]
kume = Set.new(semboller)

gorev = Task.create(1, 'tema testi', tags: %w[mor turkuaz])
board = Board.new(gorev, Task.new(2, 'gözden geçir', done: true))

kare   = ->(x) { x**2 }
topla  = proc { |a, b = 1| a + b }
blok   = lambda do |item, index|
  "#{index}: #{item}"
end

heredoc = <<~METIN
  #{BANNER} v#{VERSION}
  Görev: #{gorev.render}
  Kaçış: \t"tırnak"
METIN

ham = <<~'HAM'
  #{genisletilmez} ve \n kaçmaz
HAM

begin
  sayilar.each_with_index do |sayi, i|
    next if sayi.negative?
    break if i > 4

    print siniflandir(sayi), ' '
  end
  puts

  i = 0
  i += 1 while i < 3
  i -= 1 until i.zero?

  for n in (1..5) do
    redo if false
    next unless n.odd?
  end

  loop do
    break
  end

  raise ArgumentError, 'deneme' unless gorev.done?
rescue ArgumentError, TypeError => e
  warn "#{e.class}: #{e.message}"
rescue StandardError
  retry if (@denemeler = (@denemeler || 0) + 1) < 1
else
  puts 'hata yok'
ensure
  gorev.toggle!
end

kareler = sayilar.select { |n| n.is_a?(Integer) && n.positive? }
                 .map(&kare)
                 .each_with_object({}) { |n, acc| acc[n] = n.to_s(16) }

katalog = { ad: BANNER, 'surum' => VERSION, sayilar:, kareler: }

puts heredoc
puts ham
puts board.render
puts katalog.to_json
puts siniflandir(kareler), siniflandir(topla), siniflandir(nil)
puts blok.call(kelimeler.first, 0), kume.include?(:mor), defined?(gorev), __method__.inspect
puts Task.count, Task.banner, gorev.mor?, gorev.frozen?, (gorev <=> board).inspect

__END__
Bu bölüm yorumlanmaz.
