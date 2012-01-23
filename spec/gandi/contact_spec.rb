require 'spec_helper'
require 'gandi'

describe Gandi::Contact do
  before do
    @connection_mock = double()
    ::Gandi.connection = @connection_mock
  end
  
  context "a blank instance" do
    its(:handle) { should be_nil }
    its(:id) { should be_nil }
    its(:to_s) { should == '' }
    it { should_not be_persisted }
  end
  
  context "a new instance provided with contact infos" do
    before { @contact_information_attributes = contact_information_attributes_hash('id' => 'new id') }
    subject { Gandi::Contact.new(nil, @contact_information_attributes) }
    
    its(:handle) { should be_nil }
    its(:id) { should == 'new id' }
    its(:to_s) { should == '' }
    it { should_not be_persisted }
    
    it "should map its attributes" do
      subject.city == @contact_information_attributes['city']
      subject.to_hash['city'] == @contact_information_attributes['city']
    end
    
    it "cannot associate domains" do
      subject.can_associate_domain({:domain => 'any.tld'}).should be_false
    end
    
    it "cannot get contact informations" do
      lambda { subject.info }.should raise_error(Gandi::DataError)
    end
    
    it "cannot be updated" do
      lambda { subject.update({}) }.should raise_error(Gandi::DataError)
    end
  end
  
  context "an instance provided with its handle" do
    before do
      @handle = 'AA0-GANDI'
      @attributes = contact_information_attributes_hash('id' => 'contact id', 'handle' => @handle)
      @connection_mock.should_receive(:call).with('contact.info', @handle).and_return(@attributes)
    end
    subject { Gandi::Contact.new(@handle) }
    
    its(:handle) { should == @handle }
    its(:id) { should == 'contact id' }
    its(:to_s) { should == @handle }
    it { should be_persisted }
    
    it "can test successful domain association" do
      domain_hash = {:domain => 'mydomain.com'}
      @connection_mock.should_receive(:call).with('contact.can_associate_domain', @handle, domain_hash).and_return(true)
      subject.can_associate_domain(domain_hash).should be_true
      subject.should respond_to(:can_associate_domain?)
    end
    
    pending "can test failing domain association"
    
    it "can fetch its contact informations" do
      @connection_mock.should_receive(:call).with('contact.info', @handle).and_return(@attributes)
      subject.info['city'].should == @attributes['city']
    end
    
    it "can be updated" do
      @updated_attributes = contact_information_attributes_hash('city' => "Marseille")
      @connection_mock.should_receive(:call).with('contact.update', @handle, @updated_attributes).and_return(@updated_attributes)
      subject.update(@updated_attributes)
      subject.city.should == @updated_attributes['city']
    end
  end
  
  describe ".create" do
    it "should return a contact object" do
      attributes = contact_information_attributes_hash('id' => 'new id')
      @connection_mock.should_receive(:call).with('contact.create', attributes).and_return(attributes.merge('handle' => 'AA9-GANDI'))
      Gandi::Contact.create(attributes).handle.should == 'AA9-GANDI'
    end
  end
  
  describe ".info" do
    it "should return a contact hash" do
      attributes = contact_information_attributes_hash
      @connection_mock.should_receive(:call).with('contact.info').and_return(attributes)
      Gandi::Contact.info.should == attributes
    end
  end
  
  describe ".can_associate" do
    it "should return a boolean when the domain can be associated" do
      domain_hash = {:domain => 'mydomain.com'}
      handle = 'AA0-GANDI'
      @connection_mock.should_receive(:call).with('contact.can_associate', handle, domain_hash).and_return(true)
      Gandi::Contact.can_associate(handle, domain_hash).should be_true
    end
    
    pending "should return an error hash when the domain cannot be associated"
  end
  
  describe ".list" do
    let(:mocked_contacts_array) { [contact_information_attributes_hash('handle' => 'HA1-GANDI'), contact_information_attributes_hash('handle' => 'HA2-GANDI')] }
    
    it "returns an array of contacts" do
      @connection_mock.should_receive(:call).with('contact.list', {}).and_return(mocked_contacts_array)
      contacts = Gandi::Contact.list
      contacts.length.should == 2
      contacts.last.handle.should == 'HA2-GANDI'
    end
    
    it "can return an array of contact hashes" do
      @connection_mock.should_receive(:call).with('contact.list', {}).and_return(mocked_contacts_array)
      contacts = Gandi::Contact.list({}, false)
      contacts.length.should == 2
      contacts.last['handle'].should == 'HA2-GANDI'
    end
  end
  
  describe ".update" do
    it "returns a contact object" do
      handle = 'JD0-GANDI'
      attributes = contact_information_attributes_hash
      @connection_mock.should_receive(:call).with('contact.update', handle, attributes).and_return(attributes.merge('handle' => handle))
      Gandi::Contact.update(handle, attributes).handle.should == handle
    end
  end
end
