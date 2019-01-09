Pod::Spec.new do |spec|
  spec.name         = 'GTC'
  spec.version      = '{{.Version}}'
  spec.license      = { :type => 'GNU Lesser General Public License, Version 3.0' }
  spec.homepage     = 'https://github.com/Touchcon/go-touchconcoin'
  spec.authors      = { {{range .Contributors}}
		'{{.Name}}' => '{{.Email}}',{{end}}
	}
  spec.summary      = 'iOS Touchcon Client'
  spec.source       = { :git => 'https://github.com/Touchcon/go-touchconcoin.git', :commit => '{{.Commit}}' }

	spec.platform = :ios
  spec.ios.deployment_target  = '9.0'
	spec.ios.vendored_frameworks = 'Frameworks/GTC.framework'

	spec.prepare_command = <<-CMD
    curl https://gtcstore.blob.core.windows.net/builds/{{.Archive}}.tar.gz | tar -xvz
    mkdir Frameworks
    mv {{.Archive}}/GTC.framework Frameworks
    rm -rf {{.Archive}}
  CMD
end
