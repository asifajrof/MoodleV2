import React, { useEffect, useState } from "react";
import moment from "moment";
import AddCircleIcon from "@mui/icons-material/AddCircle";
import ReactDOM from "react-dom";
import { Link } from "react-router-dom";
const eventColors = [
	"#e6ffe5",
	"#ffe5e5",
	"#e5ffe5",
	"#e5e5ff",
	"#fae5e5",
	"#e5f5e5",
	"#e5e5e5",
];
const SectionTileContent = ({ date, view, sectionIDList }) => {
	const [eventList, setEventList] = useState([]);

	const dateMoment = moment(date);
	const dateOnly = dateMoment.date();
	const monthOnly = dateMoment.month();
	const yearOnly = dateMoment.year();

	useEffect(() => {
		const fetchData = async (calendarPostBody) => {
			try {
				const res = await fetch(`/api/calendar/getSectionSchedule`, {
					method: "POST",
					headers: {
						"Content-type": "application/json",
					},
					body: JSON.stringify(calendarPostBody),
				});
				const jsonData = await res.json();
				if (res.status === 200) {
					setEventList(jsonData.eventList);
					console.log(jsonData);
				} else {
					//   alert(jsonData.message);
					//   console.log(jsonData.message);
				}
			} catch (err) {
				console.log(err);
				// alert(err);
			}
		};
		// console.log(sectionIDList);
		fetchData({
			date: dateOnly,
			month: monthOnly,
			year: yearOnly,
			sectionList: sectionIDList,
		});
	}, [sectionIDList]);

	// list of hours
	const hours = [];
	for (let i = 0; i < 24; i++) {
		// hh:mm format
		hours.push(moment(`${i}:00`, "h:mm a").format("h:mm a"));
	}
	// console.log(hours);
	// return tileElement;
	return (
		<>
			{view === "month" ? (
				<div className="calendar__monthly__inside__content">
					{hours.map((hour, index) => {
						return (
							<div
								key={index}
								className="calendar__monthly__inside__content__line"
							>
								{/* <div style={{ background: "#000" }}>event details</div> */}
								<div className="calendar__monthly__event__list">
									{eventList.map((event, index) => {
										return (
											<div
												key={index}
												className="calendar__monthly__event__particular"
											>
												{moment(event.lookup_time, "hh:mm:ss").isBetween(
													moment(hour, "h:mm a").subtract(1, "minutes"),
													moment(hour, "h:mm a").add(1, "hour")
												) ? (
													<>
														<div
															className="calendar__monthly__event"
															style={{
																backgroundColor:
																	eventColors[event.event_id - 1],
															}}
														>
															{event.event_type_id === 1 ? (
																<>
																	{event.dept_shortname} {event.course_code}{" "}
																	{event.event_type}
																</>
															) : (
																<>
																	<Link
																		to={`/course/${event.id}/event/${event.eventid}`}
																	>
																		{event.dept_shortname} {event.course_code}{" "}
																		{event.event_type}
																	</Link>
																</>
															)}
														</div>
														<div className="calendar__monthly__hourstamp">
															{hour}
														</div>
													</>
												) : (
													<></>
												)}
											</div>
										);
									})}
								</div>
							</div>
						);
					})}
				</div>
			) : (
				<></>
			)}
		</>
	);
};

export default SectionTileContent;
