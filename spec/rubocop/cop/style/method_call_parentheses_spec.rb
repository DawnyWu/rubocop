# encoding: utf-8

require 'spec_helper'

describe RuboCop::Cop::Style::MethodCallParentheses do
  subject(:cop) { described_class.new }

  it 'registers an offense for parens in method call without args' do
    inspect_source(cop, 'top.test()')
    expect(cop.offenses.size).to eq(1)
  end

  it 'accepts parentheses for methods starting with an upcase letter' do
    inspect_source(cop, 'Test()')
    expect(cop.offenses).to be_empty
  end

  it 'accepts no parens in method call without args' do
    inspect_source(cop, 'top.test')
    expect(cop.offenses).to be_empty
  end

  it 'accepts parens in method call with args' do
    inspect_source(cop, 'top.test(a)')
    expect(cop.offenses).to be_empty
  end

  it 'auto-corrects by removing unneeded braces' do
    new_source = autocorrect_source(cop, 'test()')
    expect(new_source).to eq('test')
  end

  # These will be offenses for the EmptyLiteral cop. The autocorrect loop will
  # handle that.
  it 'auto-corrects calls that could be empty literals' do
    original = ['Hash.new()',
                'Array.new()',
                'String.new()']
    new_source = autocorrect_source(cop, original)
    expect(new_source).to eq(['Hash.new',
                              'Array.new',
                              'String.new'].join("\n"))
  end
end
