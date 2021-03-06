import { PHASE, PLAYER } from "../../common";
import { player } from "../core";
import { idb } from "../db";
import { g } from "../util";
import { ViewInput } from "../../common/types";

const updateUpcomingFreeAgents = async (
	inputs: ViewInput<"upcomingFreeAgents">,
) => {
	const stats =
		process.env.SPORT === "basketball"
			? ["min", "pts", "trb", "ast", "per"]
			: ["gp", "keyStats", "av"];
	let players: any[] =
		g.get("phase") === PHASE.RESIGN_PLAYERS
			? await idb.getCopies.players({
					tid: PLAYER.FREE_AGENT,
			  })
			: await idb.getCopies.players({
					tid: [0, Infinity],
					filter: p => p.contract.exp === inputs.season,
			  }); // Done before filter so full player object can be passed to player.genContract.

	for (let i = 0; i < players.length; i++) {
		players[i].contractDesired = player.genContract(players[i], false, false); // No randomization

		players[i].contractDesired.amount /= 1000;
		players[i].contractDesired.exp += inputs.season - g.get("season");
	}

	players = await idb.getCopies.playersPlus(players, {
		attrs: [
			"pid",
			"name",
			"abbrev",
			"age",
			"contract",
			"freeAgentMood",
			"injury",
			"contractDesired",
			"watch",
		],
		ratings: ["ovr", "pot", "skills", "pos"],
		stats,
		season: g.get("season"),
		showNoStats: true,
		showRookies: true,
		fuzz: true,
	});
	return {
		phase: g.get("phase"),
		players,
		season: inputs.season,
		stats,
	};
};

export default updateUpcomingFreeAgents;
