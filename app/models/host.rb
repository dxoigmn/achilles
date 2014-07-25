class Host < ActiveRecord::Base
  has_many :vulnerabilities
  belongs_to :location, :counter_cache => true
  belongs_to :scan, :counter_cache => true

  def visible_vulnerabilities
    vulnerabilities.select { |vulnerability| vulnerability.visible? }
  end

  def ip
    NetAddr.i_to_ip(read_attribute(:ip))
  end

  def ip=(value)
    write_attribute(:ip, NetAddr.ip_to_i(value))
    write_attribute(:location_id, Location.locate(ip).id)
  end

  def os_detected?
    !os_detection.nil?
  end

  def os_detection
    data = nil

    vulnerabilities.each do |vulnerability|
      data = vulnerability.data if vulnerability.plugin_id == Plugin::OS_DETECTION
    end

    data
  end

  def tracerouted?
    !traceroute.nil?
  end

  def traceroute
    data = nil

    vulnerabilities.each do |vulnerability|
      data = vulnerability.data if vulnerability.plugin_id == Plugin::TRACEROUTE
    end

    data
  end

  def to_s
    read_attribute(:name)
  end

  def update_severity!
    max_severity = visible_vulnerabilities.map(&:severity).delete_if { |i| i.nil? }.max rescue nil
    write_attribute(:severity, max_severity) if read_attribute(:severity) != max_severity
    save!
  end

  def self.choices
    Host.find(:all).map { |host| [host.name, host.id.to_s]}
  end
end
