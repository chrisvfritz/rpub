require 'spec_helper'

describe RPub::Book do
  let(:subject) { described_class.new('some_file', 'title' => 'My "Awesome" Title!', 'version' => '1.0.3') }

  it 'should start with an empty configuration' do
    described_class.new('some_file').config.should == {}
  end

  it             { should respond_to(:title) }
  its(:title)    { should == 'My "Awesome" Title!' }
  its(:filename) { should == 'my-awesome-title-1.0.3.epub' }

  describe 'chapters' do
    before { subject.add_chapter 'foo' }

    it { should have(1).chapters }

    it { should be_kind_of(Enumerable) }

    it 'should start with no chapters' do
      described_class.new('foo').should have(0).chapters
    end

    it 'should allow chaining multiple calls' do
      subject << 'foo' << 'bar'
      subject.should have(3).chapters
    end

    it 'should yield chapters' do
      yielded = false
      subject.each { |c| yielded = true }
      yielded.should be_true
    end
  end

  describe '#uid' do
    it 'should change when chapters change' do
      RPub::Book.new('bar').add_chapter('foo').should_not == subject.uid
    end

    it 'should change when config changes' do
      RPub::Book.new('bar', 'baz' => 'qux').should_not == subject.uid
    end
  end
end