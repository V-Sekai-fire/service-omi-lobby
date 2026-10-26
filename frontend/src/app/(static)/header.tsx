import { SiDiscord } from "@icons-pack/react-simple-icons";

import { urls } from "~/environment";
import { Banner, ClosableBannerAction } from "~/components/banner";
import { getBannerState } from "~/components/banner/server";
import { Link } from "~/components/link";

import { HeaderUserNavigation } from "./header-navigation";

export async function Header() {
	return (
		<header className="flex flex-col gap-4">
			<Banner
				actions={<ClosableBannerAction />}
				href={urls.discord}
				state={getBannerState("join-omi-discord")}
			>
				<SiDiscord className="inline size-4" /> Join the Open Metaverse
				Interoperability Group on Discord!
			</Banner>
			<div className="mx-auto flex w-full max-w-screen-xl justify-between gap-8 p-4">
				<Link className="flex h-fit shrink-0 items-center gap-4" href="/">
					<span className="text-xl font-medium">OMI Lobby</span>
				</Link>
				<nav className="flex flex-col items-end gap-2">
					<HeaderUserNavigation />
				</nav>
			</div>
		</header>
	);
}
