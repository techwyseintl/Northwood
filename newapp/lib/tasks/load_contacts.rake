namespace :northwood do

  desc "Loads a list of contacts into the database and signs them up to the Rate Watch newsletter"
    task :load_contacts => [:environment] do |t|
      require "user.rb"
      require "contact.rb"
      require "subscription.rb"
      
      if @jeff = User.find_by_email('jgreenberg@northwoodmortgage.com')
        puts "=> Adding contacts to #{@jeff.full_name} (#{@jeff.email})"
        puts
        contacts.each do |c|
          # Create the contact
          if @contact = Contact.find_by_email(c[:email])
            puts "=>> #{@contact.full_name} (#{@contact.email}) already exists on the database."
          else
            @jeff.contacts << @contact = Contact.create(c)
            puts "Created #{@contact.full_name} (#{@contact.email})"
          end  
          
          # Subscribe him to the Rate Watch newsletter
          if @contact.subscriptions.find_by_newsletter_id(1)
            puts "=>> #{@contact.full_name} (#{@contact.email}) is already a subscriber to the Rate Watch newsletter."
          else
            @contact.subscriptions << Subscription.create(:newsletter_id=>1)
            puts "Subscribed #{@contact.full_name} (#{@contact.email}) to the Rate Watch newsletter."
          end
        end
      else
        puts "=>> Couldn't find Jeff's account (jgreenberg@northwoodmortgage.com)"
        puts "Exiting..."
      end  
    end
  
  
  def contacts  
    [
      {:first_name =>'Sid', :last_name=>'Rochwerg', :email=>'Sid_Rochwerg@adp.com'},
      {:first_name =>'Jennifer', :last_name=>'Rode', :email=>'jennifer.rode@paramountparks.com'},
      {:first_name =>'Chris', :last_name=>'Lamb', :email=>'clamb@IRMC.com'},
      {:first_name =>'Aaron', :last_name=>'Seaton', :email=>'aaron.seaton@cgi.com'},
      {:first_name =>'Bill', :last_name=>'Tyrell', :email=>'bill_tyrell@dell.com'},
      {:first_name =>'Mark', :last_name=>'Waxman', :email=>'markw@dotben.com'},
      {:first_name =>'Philipe', :last_name=>'Dunsky', :email=>'philippe@dunsky.ca'},
      {:first_name =>'Marc', :last_name=>'Lefler', :email=>'mlefler@tor.fasken.com'},
      {:first_name =>'Mark', :last_name=>'Lecker', :email=>'mark.lecker@ca.fujitsu.com'},
      {:first_name =>'Pnina', :last_name=>'Lutwak', :email=>'pnina@tpscan.com'},
      {:first_name =>'Domenic', :last_name=>'Zucco', :email=>'domenic@piattovecchio.com'},
      {:first_name =>'Morgan', :last_name=>'Matthews', :email=>'morgan@impactmachine.com'},
      {:first_name =>'John', :last_name=>'McClean', :email=>'john.mcclean@sympatico.ca'},
      {:first_name =>'Anne', :last_name=>'Woodley', :email=>'anne.woodley@ironmountain.com'},
      {:first_name =>'Mike', :last_name=>'Sugar', :email=>'lawnsigns@rogers.com'},
      {:first_name =>'Ronnie', :last_name=>'Lebow', :email=>'lebow@sympatico.ca'},
      {:first_name =>'Revi', :last_name=>'Kay', :email=>'revikay@monacointeriors.ca'},
      {:first_name =>'Michael', :last_name=>'Spiegel', :email=>'mspiegel@newmar.com'},
      {:first_name =>'Chris', :last_name=>'', :email=>'noizeboyz@noizeboyz.com'},
      {:first_name =>'John', :last_name=>'Tsilfidis', :email=>'offthebench@rogers.com'},
      {:first_name =>'Gus', :last_name=>'Dagher', :email=>'gus@postersunlimited.ca'},
      {:first_name =>'Rada', :last_name=>'Glazas', :email=>'rada@prosilkscreen.com'},
      {:first_name =>'Saundra', :last_name=>'Topp', :email=>'saundra@progressluv2pak.com'},
      {:first_name =>'Jeremy', :last_name=>'Fink', :email=>'jfink@sblr.ca'},
      {:first_name =>'Sushan', :last_name=>'Soni', :email=>'sushan@sonitek.ca'},
      {:first_name =>'Joel', :last_name=>'Awerbuck', :email=>'joel@spankfilm.com'},
      {:first_name =>'Saul', :last_name=>'Henechowicz', :email=>'saulh@strycowire.com'},
      {:first_name =>'Steven', :last_name=>'Beagle', :email=>'sbeagle@sympatico.ca'},
      {:first_name =>'Andrew', :last_name=>'Ross', :email=>'andrew.ross@telus.com'},
      {:first_name =>'Ash', :last_name=>'Shah', :email=>'ashish.shah@telus.com'},
      {:first_name =>'Lawrence', :last_name=>'Bender', :email=>'lawrence@tpscan.com'},
      {:first_name =>'Faith', :last_name=>'Robert', :email=>'fandg@rogers.com'},
      {:first_name =>'Jeremy', :last_name=>'Wesley', :email=>'jwesley@dpii.ca'},
      {:first_name =>'Rob', :last_name=>'Neveau', :email=>'rob@customcomputers4u.com'},
      {:first_name =>'Yolanda', :last_name=>'Bertucci', :email=>'bertton@bellnet.ca'},
      {:first_name =>'Ken', :last_name=>'Wolfson', :email=>'kwolfson@vif.com'},
      {:first_name =>'Vince', :last_name=>'Fracassi', :email=>'fonatural@aol.com'},
      {:first_name =>'Adam', :last_name=>'Sherman', :email=>'adam@ihaterogers.ca'},
      {:first_name =>'Gerry', :last_name=>'Pressman', :email=>'dragpres@tor.axxent.ca'},
      {:first_name =>'Dave', :last_name=>'Greenberg', :email=>'davegreenberg67@hotmail.com'},
      {:first_name =>'Alison', :last_name=>'Davidson', :email=>'alison@swim-time.com'},
      {:first_name =>'Josh', :last_name=>'Ashcenaczi', :email=>'info@safezonesecurity.com'},
      {:first_name =>'Les', :last_name=>'Bellack', :email=>'zephyr_me@hotmail.com'},
      {:first_name =>'Brian', :last_name=>'Krinberg', :email=>'russian09@hotmail.com'},
      {:first_name =>'Dan', :last_name=>'Watts', :email=>'dwatts1@rogers.com'},
      {:first_name =>'Jeff', :last_name=>'Levy', :email=>'jeff@handeeproducts.com'},
      {:first_name =>'Colin', :last_name=>'Cummins', :email=>'ccummins@redeyebaseball.com'},
      {:first_name =>'Jude', :last_name=>'Pattenden', :email=>'heyjude_3@hotmail.com'},
      {:first_name =>'Al', :last_name=>'Patel', :email=>'patels@rogers.com'},
      {:first_name =>'Michelle', :last_name=>'Desmormeaux', :email=>'mishi85@rogers.com'},
      {:first_name =>'Kevin', :last_name=>'Grant', :email=>'kevingrant@rogers.com'},
      {:first_name =>'Robert', :last_name=>'Hansel', :email=>'robert.hansel@rogers.com'},
      {:first_name =>'Denise', :last_name=>'Simmons', :email=>'paul321@sympatico.ca'},
      {:first_name =>'Kurt', :last_name=>'Bradley', :email=>'can_muscle@yahoo.co.uk'},
      {:first_name =>'Kathee', :last_name=>'Everett', :email=>'katheeeverett@hotmail.com'},
      {:first_name =>'Bill', :last_name=>'Economopoulos', :email=>'bill_economopoulos@dell.com'},
      {:first_name =>'Peter', :last_name=>'Tsang', :email=>'p.tsang37@rogers.com'},
      {:first_name =>'Steve', :last_name=>'Epstein', :email=>'steven@dagsandwillow.ca'},
      {:first_name =>'Gerri', :last_name=>'Holder', :email=>'gholder@rogers.com'},
      {:first_name =>'Jason', :last_name=>'MacDonald', :email=>'wiredup@rogers.com'},
      {:first_name =>'Steve', :last_name=>'Gaines', :email=>'sgaines@sympatico.ca'},
      {:first_name =>'Rick', :last_name=>'Green', :email=>'rick@greenhousegraphics.ca'},
      {:first_name =>'Rob', :last_name=>'Little', :email=>'rlittle@nortownair.com'},
      {:first_name =>'Rob', :last_name=>'Shendelman', :email=>'rob.shendelman@sympatico.ca'},
      {:first_name =>'Olive', :last_name=>'Baston', :email=>'wiccann68@hotmail.com'},
      {:first_name =>'Vikki', :last_name=>'Bellack', :email=>'victoria.bellack@cibc.ca'},
      {:first_name =>'Sy', :last_name=>'Benlolo', :email=>'syben@rogers.com'},
      {:first_name =>'Monte', :last_name=>'Braunstein', :email=>'leasemax@sprint.ca'},
      {:first_name =>'Darren', :last_name=>'Brooks', :email=>'dbrook0496@rogers.com'},
      {:first_name =>'Aaron', :last_name=>'Kashin', :email=>'akashin@sympatico.ca'},
      {:first_name =>'Nick', :last_name=>'Lapiccirella', :email=>'sawchuknick@hotmail.com'},
      {:first_name =>'Amy', :last_name=>'Pataki', :email=>'jpataki@sympatico.ca'},
      {:first_name =>'Mitch', :last_name=>'Rabovsky', :email=>'mrcarcare@hotmail.com'},
      {:first_name =>'Wasim', :last_name=>'Rana', :email=>'wasim.rana@sunlife.com'},
      {:first_name =>'Ryeha', :last_name=>'Saifi', :email=>'rsaifi@yahoo.com'},
      {:first_name =>'Marc', :last_name=>'Saltzman', :email=>'gameguy@rogers.com'},
      {:first_name =>'Mark', :last_name=>'Schwartz', :email=>'mark77mark@hotmail.com'},
      {:first_name =>'Andrew', :last_name=>'Sefton', :email=>'andrew.sefton@sympatico.ca'},
      {:first_name =>'Evan', :last_name=>'Silver', :email=>'esilver@bianix.com'},
      {:first_name =>'Mitch', :last_name=>'Silverman', :email=>'silvermanmitch@hotmail.com'},
      {:first_name =>'Perry', :last_name=>'Simardone', :email=>'perryps@aol.com'},
      {:first_name =>'Steven', :last_name=>'Snitman', :email=>'music-man1@rogers.com'},
      {:first_name =>'Libby', :last_name=>'Vosberg', :email=>'lsvee@rogers.com'},
      {:first_name =>'Michael', :last_name=>'Winton', :email=>'mwinton@marwingroup.com'},
      {:first_name =>'Robert', :last_name=>'Yelenich', :email=>'robert_yelenich@dell.com'},
      {:first_name =>'Rana', :last_name=>'Rosen', :email=>'rana.rosen@ypg.com'},
      {:first_name =>'Adam', :last_name=>'Altberg', :email=>'adam.altberg@nbpcd.com'},
      {:first_name =>'Bobby', :last_name=>'Sole', :email=>'sole99@rogers.com'},
      {:first_name =>'Josh', :last_name=>'Obront', :email=>'djjelo@hotmail.com'},
      {:first_name =>'Danny', :last_name=>'Kagan', :email=>'dkagan@xenos.com'},
      {:first_name =>'Dawn', :last_name=>'Liu-Smyth', :email=>'dawn@gurglesandgiggles.ca'},
      {:first_name =>'Kevin', :last_name=>'Rosenthall', :email=>'kevin@rosenthall.com'},
      {:first_name =>'Danny', :last_name=>'Benekiel', :email=>'danny@reflectionsfurniture.net'},
      {:first_name =>'Ann', :last_name=>'Lovegrove', :email=>'alovegrove@patonpublishing.com'},
      {:first_name =>'Yinka', :last_name=>'Obasa', :email=>'yinkobasa@yahoo.com'},
      {:first_name =>'Ayelet', :last_name=>'Kleiner', :email=>'akleiner17@hotmail.com'}
    ]
  end
end
